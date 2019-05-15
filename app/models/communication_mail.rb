class CommunicationMail < ActiveRecord::Base
  include Bootsy::Container


end

private

def post_params
  params.require(:content).permit(:content)
end