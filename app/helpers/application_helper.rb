module ApplicationHelper
    def controller_index_urls
        controllers = Dir[Rails.root.join('app/controllers/*_controller.rb')].map do |file|
          controller_name = file.split('/').last.gsub('_controller.rb', '')
          view_folder = Rails.root.join('app/views', controller_name)
          
          if Dir.exist?(view_folder)
            {
              name: controller_name.humanize,
              url: "/#{controller_name.pluralize}",
              created_at: File.ctime(file)
            }
          end
        end.compact
    
        sorted_controllers = controllers.sort_by { |controller| controller[:created_at] }.reverse
    
        sorted_controllers.map do |controller|
          {
            name: controller[:name],
            url: controller[:url]
          }
        end
      end
end
