# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# PRevent paperclip from adding timestamps to all URLs, as it does by default
Paperclip::Attachment.default_options[:use_timestamp] = false
