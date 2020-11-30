#######################################################################################################
#
# Terraform does not have a easy way to check if the input parameters are in the correct format.
# On top of that, terraform will sometimes produce a valid plan but then fail during apply.
# To handle these errors beforehad, we're using the 'file' hack to throw errors on known mistakes.
#
#######################################################################################################
locals {
  # Regular expressions

  regex_instance_name = "(?:[a-z](?:[-a-z0-9]{0,38}[a-z0-9])?)"

  # Terraform assertion hack
  assert_head = "\n\n-------------------------- /!\\ ASSERTION FAILED /!\\ --------------------------\n\n"
  assert_foot = "\n\n-------------------------- /!\\ ^^^^^^^^^^^^^^^^ /!\\ --------------------------\n"
  asserts = {
    for instance, settings in local.instances : instance => merge({
      instancename_too_long = length(settings.name) > 40 ? file(format("%sinstance [%s]'s generated name is too long:\n%s\n%s > 40 chars!%s", local.assert_head, instance, settings.name, length(settings.name), local.assert_foot)) : "ok"
      instancename_regex    = length(regexall("^${local.regex_instance_name}$", settings.name)) == 0 ? file(format("%sinstance [%s]'s generated name [%s] does not match regex ^%s$%s", local.assert_head, instance, settings.name, local.regex_instance_name, local.assert_foot)) : "ok"
      keytest = {
        for setting in keys(settings) : setting => merge(
          {
            keytest = lookup(local.instance_defaults, setting, "!TF_SETTINGTEST!") == "!TF_SETTINGTEST!" ? file(format("%sUnknown instance variable assigned - instance [%s] defines [%q] -- Please check for typos etc!%s", local.assert_head, instance, setting, local.assert_foot)) : "ok"
        }) if setting != "name"
      }
    })
  }
}
