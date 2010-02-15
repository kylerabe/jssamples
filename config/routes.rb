ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # The following makes 'reorder' an action, not an id
  map.connect   ':controller/reorder', :action => 'reorder'

  # Create RESTful routes for Specs
  #map.resources :specs
  
  # Create RESTful routes for Populars (most popular items)
  #map.resources :populars

  # Create RESTful routes for Cross-Sale Groups
  map.resources :cross_sale_groups
  map.resources :items

  # Create named routes for associating/dissociating items with Cross-Sale Groups
  map.associate_item_with_cross_sale_group  'cross_sale_groups/:id/item',
                                            :controller => 'cross_sale_groups',
                                            :action => 'associate_item',
                                            :conditions => {:method => :post}
  map.dissociate_item_from_cross_sale_group 'cross_sale_groups/:id/item/:item_id',
                                            :controller => 'cross_sale_groups',
                                            :action => 'dissociate_item',
                                            :conditions => {:method => :delete}

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
