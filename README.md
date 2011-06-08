# FIDIUS Snortor

Snortor provides an interface to configure snort rules. 
You can:

  *   import rules 
  *   export rules 
  *   find rules by message
  *   activate or deactivate single rules  
  *   import/export possible via scp

## Installation

Simply install this package with Rubygems:

    $ gem install snortor

## Usage

Some examples on how Snortor can be used.

    require 'snortor'

    # import some rules from remote host
    Snortor.import_rules({:host=>"10.10.10.254",:user=>"root",:password=>"xxx",:remote_path=>"/etc/snort/rules/"})

    # or import rule files from local path
    Snortor.import_rules("/home/user/myrules")

    # work with your rules
    puts "#{Snortor.rules.size}"
    puts "#{Snortor.rules[1].active}"
    Snortor.rules[1].active = false

    # find specific rules 
    rule = Snortor.rules.find_by_msg("BAD-TRAFFIC")
    rule.active = true

    # find all rules by name
    rules = Snortor.rules.find_all_by_msg("BAD-TRAFFIC")    
    rules.each do |rule|
      rule.active = false
    end

    Snortor.export_rules({:host=>"10.10.10.254",:user=>"root",:password=>"xxx",:remote_path=>"/etc/snort/rules/"})

## Authors and Contact

fidius-evasiondb was written by

* FIDIUS Intrusion Detection with Intelligent User Support
  <grp-fidius+evasiondb@tzi.de>, <http://fidius.me>
* in particular:
 * Bernhard Katzmarski <bkatzm+snortor@tzi.de>

If you have any questions, remarks, suggestion, improvements, etc. feel free to drop a line at the 
addresses given above. You might also join `#fidius` on Freenode or use the contact form on our
[website](http://fidius.me/en/contact).


# Acknowledgement

This Gem uses snort-rule from Chris Lee which provided the ability to parse rules.

## License

Simplified BSD License and GNU GPLv2. See also the file LICENSE.
