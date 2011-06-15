require 'rubygems'
BASE = File.expand_path('..', __FILE__)

require 'snort-rule'
require 'net/ssh'
require 'net/scp'
require File.join(BASE,'rule')
require File.join(BASE,'rulefile')
require File.join(BASE,'rulefile_collection')
require 'tmpdir'

#Snortor provides an interface to configure snort rules. You can:
#  *   import rules 
#  *   export rules 
#  *   find rules by message
#  *   activate or deactivate single rules  
#  *   import/export possible via scp
module Snortor
  class << self
    @@rules = RulefileCollection.new

    # after import you can work with the rules like
    #   puts "#{Snortor.rules.size}"
    #   puts "#{Snortor.rules[1].active}"
    #   Snortor.rules[1].active = false
    #
    def rules
      @@rules
    end

    # imports rules from a local_path or via scp connection from a remote host.
    #
    #   import_rules("/my/local/path")
    #
    #   import_rules({:host=>x,:user=>x,:password=>x,:remote_path=>x})
    def import_rules(args)
      clear
      if args.class == Hash
        @@rules.import_rules(download_from_host(args))
      elsif args.class == String
        @@rules.import_rules(args)
      else
        raise "can not use #{args.class}. provide string or hash for import_rules"
      end
    end

    # exports rules to a local directory or via scp connection to a remote host.
    #
    #   export_rules("/my/local/path")
    #
    #   export_rules({:host=>x,:user=>x,:password=>x,:remote_path=>xa})
    def export_rules(args)
      if args.class == Hash
        local_path = args[:local_path]
        puts "export_rules #{Dir.tmpdir}"
        local_path = File.join(Dir.tmpdir,"rules") unless local_path

        puts "localpath: #{local_path}"
        Dir.mkdir(local_path) if !File.exists?(local_path)
        puts "localpath: #{local_path}"
        @@rules.write_rules(local_path)
        args[:local_path] = local_path

        puts "args: #{args[:local_path]}"
        upload_to_host(args)
      elsif args.class == String
        @@rules.write_rules(args)
      else
        raise "can not use #{args.class}. provide string or hash for export_rules"
      end
    end

    def download_from_host(conn={})
      if conn[:local_path]
        local_path = conn[:local_path]
      else
        local_path = File.join(Dir.tmpdir)
      end
      Dir.mkdir(local_path) unless File.exists?(local_path)
      raise "no host given for scp download" unless conn[:host]
      raise "no user given for scp download" unless conn[:user]
      raise "no password given for scp download" unless conn[:password]
      raise "no path given for scp download" unless conn[:remote_path]

      options = {}
      options[:password] = conn[:password]
      options = options.merge(conn[:options])

      puts "dowload rules from remote:#{conn[:remote_path]} to #{local_path}"
      Net::SSH.start(conn[:host], conn[:user], options) do |ssh|
        ssh.scp.download! conn[:remote_path], local_path,:recursive=>true
        #ssh.scp.upload! "/home/bernd/fidius/snortor/rules/rules/x11.rules", "/root/x11.rules"
      end
      puts "rules are in "+local_path+"/rules"
      return local_path+"/rules"
    end

    def upload_to_host(conn={})
      raise "no host given for scp upload" unless conn[:host]
      raise "no user given for scp upload" unless conn[:user]
      raise "no password given for scp upload" unless conn[:password]
      raise "no remote_path given for scp upload" unless conn[:remote_path]
      raise "no local_path given for scp upload" unless conn[:local_path]

      options = {}
      options[:password] = conn[:password]
      options = options.merge(conn[:options]) if conn[:options]


      puts "upload from #{conn[:local_path]} to #{conn[:remote_path]}"
      Net::SSH.start(conn[:host], conn[:user], options) do |ssh|
        ssh.scp.upload! conn[:local_path], conn[:remote_path],:recursive=>true
      end
    end    

    # clears the rule array
    # 
    def clear
      @@rules.clear
    end
    
    # find a rule by its message
    #   rule = Snortor.rules.find_by_msg("BAD-TRAFFIC")
    def find_by_msg(msg)
      @@rules.find_by_msg(msg)
    end

    # find all rules by its message
    #   rules = Snortor.rules.find_all_by_msg("BAD-TRAFFIC")    
    def find_all_by_msg(msg)
      @@rules.find_all_by_msg(msg)
    end
  end
end
