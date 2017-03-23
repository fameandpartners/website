require 'spec_helper'

describe WeddingAtelier::SlackCallbacksController, type: :controller do
  before(:each) { enable_wedding_atelier_feature_flag }

  describe '#create' do
    let(:payload) {
      "{\"actions\":[{\"name\":\"reply\",\"type\":\"button\",\"value\":\"http:\\/\\/au.lvh.me:3000\\/wedding-atelier\\/events\\/1\\/aasdasda\"}],\"callback_id\":\"cust_sup\",\"team\":{\"id\":\"T026PUF20\",\"domain\":\"fameandpartners\"},\"channel\":{\"id\":\"C4DFPHNE6\",\"name\":\"wedding-app-chats\"},\"user\":{\"id\":\"U34SXT347\",\"name\":\"foobar\"},\"action_ts\":\"1489686408.848480\",\"message_ts\":\"1489686401.829361\",\"attachment_id\":\"1\",\"token\":\"slack_token\",\"is_app_unfurl\":false,\"original_message\":{\"text\":\"\",\"bot_id\":\"B4JUMMVMK\",\"attachments\":[{\"callback_id\":\"cust_sup\",\"text\":\"payload\",\"id\":1,\"fields\":[{\"title\":\"User\",\"value\":\"Foo Bar (<mailto:foobar@gmail.com|foobar@gmail.com>)\",\"short\":false},{\"title\":\"Wedding date\",\"value\":\"03\\/31\\/2017\",\"short\":true},{\"title\":\"Dresses in board\",\"value\":\"1\",\"short\":true},{\"title\":\"Cart value\",\"value\":\"$249.00\",\"short\":true},{\"title\":\"Date joined\",\"value\":\"03\\/09\\/2017\",\"short\":true}],\"actions\":[{\"id\":\"1\",\"name\":\"reply\",\"text\":\"Reply\",\"type\":\"button\",\"value\":\"event_url\",\"style\":\"primary\"}],\"fallback\":\"NO FALLBACK DEFINED\"}],\"type\":\"message\",\"subtype\":\"bot_message\",\"ts\":\"1489686401.829361\"},\"response_url\":\"https:\\/\\/hooks.slack.com\\/actions\\/T026PUF20\\/154829725169\\/ivdERrcT95oUp3kePp3NMUtb\"}"
    }

    context 'when token verification passes' do
      before do
        allow(ENV).to receive(:[]).with('SLACK_VERIFICATION_TOKEN').and_return('slack_token')
      end

      it 'replaces the original message with the board link' do
        post :create, { payload: payload }
        json_response = JSON.parse(response.body)
        expect(json_response['response_type']).to eq 'in_channel'
        expect(json_response['replace_original']).to be_truthy
        expect(json_response['attachments'][0]['fields'].last['title']).to eq 'Board link'
        expect(json_response['attachments'][0]['fields'].last['value']).to match(/event_url/)
      end
    end

    context 'when token verification doesnt pass' do
      before do
        allow(ENV).to receive(:[]).with('SLACK_VERIFICATION_TOKEN').and_return('invalid_token')
      end

      it 'responds false' do
        post :create, { payload: payload }
        json_response = JSON.parse(response.body)
        expect(json_response['ok']).to be_falsey
      end
    end
  end
end
