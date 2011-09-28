require "dor/util"

class PurlController < ApplicationController

  before_filter :validate_id
  before_filter :load_purl

  # entry point into the application
  def index
    # validate that the metadata is ready for delivery
    if( @purl.is_ready? )
      # render the landing page based on the format
      respond_to do |format|
        format.html {
          # if the object is an image, render image specific layout
          if (@purl.is_image?)
            render :partial => "purl/image/contents", :layout => "purl_image"
          end        
        }
      
        format.xml { 
          render :xml => @purl.public_xml 
        }
      end
    else
      render :partial => "purl/unavailable", :layout => "application"
      return false
    end  
  end

  private

  # validate that the id is of the proper format
  def validate_id
    
    # handle a single static grandfathered exception
    if(params[:id] == 'ir:rs276tc2764')
      redirect_to "/ir:rs276tc2764/index.html"
      return
    end

    if( !Dor::Util.validate_druid(params[:id]) )
      render :status => 404, :file => "#{RAILS_ROOT}/public/404.html"
      return false
    end
    true
  end
  
  def load_purl
    @purl = Purl.find(params[:id])
    # Catch well formed druids that don't exist in the document cache
    if(@purl.nil?)
      render :status => 404, :file => "#{RAILS_ROOT}/public/404.html"
      return false
    end
    true
  end

end

