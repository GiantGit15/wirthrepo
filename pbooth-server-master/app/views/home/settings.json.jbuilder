#settings_hash = {
#  "image_ratio" => @event.image_ratio,
#  "share_copy_title" => @event.copy_email_subject,
#  "share_copy_body" => @event.copy_email_body,
#  "share_copy_social" => @event.copy_social,
#  "share_copy_twitter" => @event.copy_twitter,
#  "multiple_orientations" => @event.multiple_orientations
#}
#
#p settings_hash
#
#json.settings settings_hash

json.event @event
