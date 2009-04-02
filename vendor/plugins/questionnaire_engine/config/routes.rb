# custom routes for administration

ActionController::Routing::Routes.draw do |map|
  map.resources :questionnaires, 
    :path_prefix => '/admin', 
    :collection => { :import => :post },
    :member     => { :reorder => :post,
      :copy => :post,
      :export => :get } do |questionnaires|

    questionnaires.resources :pages,      # pages controller
      :collection => { :import => :post },
      :member =>     { :set_page_title => :post,
        :reorder => :post,
        :export => :get,
        :set_flag => :post,
        :copy => :post } do |pages|

      pages.resources :elements,          # elements controller 
        :collection => { :show_element_form => :post },
        :member =>     { :set_element_text => :post,
          :set_element_max_length => :post,
          :reorder => :post,
          :change_type => :post,
          :set_flag => :post,
          :copy => :post }
        end
      end

  map.resources :question_options,
    :member =>     { :set_question_option_option => :post, 
      :set_question_option_value => :post },
      :collection => { :reorder => :post }
end
