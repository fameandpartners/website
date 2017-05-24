cache [:collections_rss, 'collections_rss', current_site_version.code], expires_in:  configatron.cache.expire.long  do
	xml.instruct! :xml, :version => "1.0"
	xml.rss :version => "2.0" do
	  xml.channel do
	    xml.title "Fame and Partners"
	    xml.description "Fashion"
	    xml.link "fameandpartners.com"

	    @collections.each do |taxon|
	      xml.item do
	        xml.title taxon.name
	        xml.description taxon.meta_description
	        xml.link "http://fameandpartners.com#{build_taxon_path(taxon.name)}"
	        xml.guid "http://fameandpartners.com#{build_taxon_path(taxon.name)}"
	      end
	    end
	  end
	end
end
