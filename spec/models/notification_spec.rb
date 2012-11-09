# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  notifier_id :integer
#  notified_id :integer
#  message     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'spec_helper'

describe Notification do
  pending "add some examples to (or delete) #{__FILE__}"
end
