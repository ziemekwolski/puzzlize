module Puzzlize
  class Railtie < Rails::Railtie
    initializer 'puzzlize.model_additons' do
      ActiveSupport.on_load :active_record do
        extend ModelAdditions
        
        ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, Puzzlize::Schema)
        ActiveRecord::ConnectionAdapters::Table.send(:include, Puzzlize::Schema)
        ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, Puzzlize::Schema)
      end
      
      ActiveSupport.on_load :action_view do
        include ViewHelpers
      end
    end
  end
end