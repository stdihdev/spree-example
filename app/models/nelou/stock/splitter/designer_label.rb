module Nelou
  module Stock
    module Splitter
      class DesignerLabel < Spree::Stock::Splitter::Base

        def split(packages)
          split_packages = []
          packages.each do |package|
            split_packages += split_by_designer_label(package)
          end
          return_next split_packages
        end

        protected

        def split_by_designer_label(package)
          labels = Hash.new { |hash, key| hash[key] = [] }
          package.contents.each do |item|
            labels[item.variant.designer_label_id] << item
          end
          hash_to_packages(labels)
        end

        def hash_to_packages(labels)
          packages = []
          labels.each do |id, contents|
            packages << build_package(contents)
          end
          packages
        end

      end
    end
  end
end
