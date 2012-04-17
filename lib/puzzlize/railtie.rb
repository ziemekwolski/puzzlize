module Puzzlize
  module Railtie < Rails::Railtie
    initializer 'puzzlize.model_additons' do
      ActiveSupport.on_load :active_record do
        extend ModelAdditons
      end
      
      ActiveSupport.on_load :action_view do
        include ViewHelpers
      end
    end
  end
end