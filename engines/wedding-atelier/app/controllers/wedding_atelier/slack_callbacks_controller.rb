require_dependency "wedding_atelier/application_controller"
module WeddingAtelier
  class SlackCallbacksController < ApplicationController
    skip_before_filter :authenticate_spree_user!, only: :create

    def create
      payload = JSON.parse(params['payload'])
      if(payload['token'] == ENV['SLACK_VERIFICATION_TOKEN'])
        attachment = payload['original_message']['attachments'][0]
        user = payload['user']
        action = attachment.delete('actions').detect{ |action| action['name'] == 'reply' } || {}

        attachment['fields'].push({
          title: "Board link",
          value: "#{action['value']} \n <@#{user['id']}|#{user['name']}> :white_check_mark: "
        })

        render json: {
          response_type: 'in_channel',
          replace_original: true,
          attachments: [attachment]
        }
      else
        render json: { ok: false }
      end
    end
  end
end
