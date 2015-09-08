require 'digest/md5'

Puppet::Type.newtype(:track) do
  @doc = %q{Track MD5 checksums of files, so that external tracking tools like
  Jenkins deployment notification plugin can find out what files are in the system.

    Example:

      track { '/usr/share/foo/foo.war'}
  }

  newproperty(:md5) do |property|  
    defaultto :computed
    
    def retrieve
	    :computed
    end
   
#    def change_to_s(cur,newv)
#    end

    def sync
  	  digest = Digest::MD5.new
      File.open(self.resource[:name], 'rb') do |file|
        while content = file.read(4192)
          digest << content
        end
      end
  
      @md5 = digest.hexdigest
    
    	self.notice "{md5}#@md5"
    end
 end
 
  newparam(:name) do
    desc "Path of the file name to track."
    isnamevar
  end

	def refresh
	  self.property(:md5).sync
	end

end
