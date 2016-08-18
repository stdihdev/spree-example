# Shamelessly stolen from
# @see https://gist.github.com/audionerd/4703b4ed3ddad82999f7

module Nelou
  module HasCustomFileName
    extend ActiveSupport::Concern

    def generate_hex_for_file_name(file_name)
      '%s%s' % [SecureRandom.hex(8), File.extname(file_name).downcase]
    end

    module ClassMethods
      def has_custom_file_name(attachment_name, callback)
        send(:"before_#{attachment_name}_post_process", :"set_#{attachment_name}_file_name")

        define_method :"set_#{attachment_name}_file_name" do |*_args|
          old_file_name = send(:"#{attachment_name}_file_name")
          new_file_name = send(callback, old_file_name)
          send(attachment_name).instance_write(:file_name, new_file_name)
        end
      end
    end
  end
end
