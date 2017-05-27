class FacebookSync
  def initialize( key )
    @access_key = key
    @base_uri = 'https://graph.facebook.com/v2.9'
    @next_token = nil
  end

  def next_page
    response = begin
                 RestClient.get(generate_uri, accept: :json, accept_encoding: :identity)
               rescue RestClient::Exception => e
                 puts e.response
               end
    results = JSON.parse( response )
    account_array = results['data']
    account = account_array.find { |account| account['name'] == "Fame & Partners #2" }
    @next_token = account['campaigns']['paging']['cursors']['after']
    account
  end

  private
  
  def generate_uri
    if( @next_token.nil? )
      "#{@base_uri}/me/adaccounts?fields=name,account_status,age,amount_spent,currency,campaigns.filtering([{'field':'campaign.effective_status', 'operator':'IN', 'value':['ACTIVE']}]).limit(5){name,created_time,start_time,stop_time,updated_time,status,recommendations,adsets.filtering([{'field':'adset.effective_status', 'operator':'IN', 'value':['ACTIVE']}]){name,adlabels,adset_schedule,bid_amount,daily_budget,created_time,updated_time,start_time,end_time,optimization_goal,status,targeting,ads.filtering([{'field':'ad.effective_status', 'operator':'IN', 'value':['ACTIVE']}]){name,created_time,updated_time,bid_amount,status,recommendations,creative{body,call_to_action_type,image_url,instagram_permalink_url,link_url,name,status,title,video_id},insights.time_range({'since':'2017-05-25','until':'2017-05-25'}).time_increment(1){clicks,cost_per_action_type,cpc,cpm,cpp,ctr,date_start,date_stop,frequency,reach,relevance_score,social_impressions,spend,total_actions,total_unique_actions,website_ctr,website_clicks},adcreatives{image_url}}}}&access_token=#{@access_key}"
    else
      sprintf( "%s/me/adaccounts?fields=name,account_status,age,amount_spent,currency,campaigns.filtering([{'field':'campaign.effective_status', 'operator':'IN', 'value':['ACTIVE']}]).limit(5).after('%s'){name,created_time,start_time,stop_time,updated_time,status,recommendations,adsets.filtering([{'field':'adset.effective_status', 'operator':'IN', 'value':['ACTIVE']}]){name,adlabels,adset_schedule,bid_amount,daily_budget,created_time,updated_time,start_time,end_time,optimization_goal,status,targeting,ads.filtering([{'field':'ad.effective_status', 'operator':'IN', 'value':['ACTIVE']}]){name,created_time,updated_time,bid_amount,status,recommendations,creative{body,call_to_action_type,image_url,instagram_permalink_url,link_url,name,status,title,video_id},insights.time_range({'since':'2017-05-25','until':'2017-05-25'}).time_increment(1){clicks,cost_per_action_type,cpc,cpm,cpp,ctr,date_start,date_stop,frequency,reach,relevance_score,social_impressions,spend,total_actions,total_unique_actions,website_ctr,website_clicks},adcreatives{image_url}}}}&access_token=%s", @base_uri, @next_token, @access_key )
    end
  end
  
  
end
