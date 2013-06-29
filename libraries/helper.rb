module PGina
  module Helper
  
    #
    # Some values in the registry entries are padded with \n characters
    # These helper methods handle that
    #
    
    def ldap_gateway_group_rules(always = [],if_member = {},not_if_member = {})
      result = []
    
      # Always
      always.each do |g|
        g.prepend("\n2\n")
        result.push(g)
      end
      
      if_member.each do |ldapgroup,groups|
        groups.each do |g|
          result.push(ldapgroup + "\n0\n" + g)
        end
      end
      
      not_if_member.each do |ldapgroup,groups|
        groups.each do |g|
          result.push(ldapgroup + "\n1\n" + g)
        end
      end
      
      return result
    end
    
    def ldap_authz_rules(groups)
      result = []
      if groups.empty?
        # Default to allow
        result.push("\n2\n1")
      else
        groups.each_with_index do |g,i|
          # The 01 at the end indicates allow
          result.push(g + "\n0\n1")
        end
        # Default to deny
        result.push("\n2\n0")
      end
      return result
    end
  end
end