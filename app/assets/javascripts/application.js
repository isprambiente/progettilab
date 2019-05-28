// ########################################
// #    NECESSARIE
// ########################################
//= require jquery3
//= require moment
//= require jquery.cookie
//= require jquery.purr
//= require jquery_ujs
//= require jquery-ui
//= require jquery.datetimepicker

//= require activestorage

// ########################################
// #    FOUNDATION
// ########################################
//= require foundation

// ########################################
// #    datatables
// ########################################
//= require datatables/datatables
//= require datatables/datatables.responsive
//= require datatables/datatables.foundation
//= require datatables/responsive.foundation
//= require datatables/buttons.foundation
//= require datatables/jszip
//= require datatables/buttons.html5
//= require datatables/buttons.print
//= require datatables/buttons.pdf
//= require datatables/buttons.colVis
//= require datatables/vfs_fonts

// ########################################
// #    ALTRE
// ########################################
//= require cocoon
//= require jquery.remotipart
//= require select2
//= require select2_locale_en
//= require select2_locale_it
//= require jquery.sticky

// ########################################
// #    CUSTOM
// ########################################
//= require custom
//= require menubar
//= require jobs
//= require timetables
//= require logs
//= require users
//= require samples
//= require analisies
//= require nuclides
//= require units
//= require matrix_types
//= require analisy_types
//= require instructions
//= require reports
//= require news
//= require upload
//= require import

//= require turbolinks

$.datetimepicker.setLocale( $('html').attr( 'lang' ) );
$.fn.select2.defaults.set("", "");
$(function(){ $(document).foundation(); });
