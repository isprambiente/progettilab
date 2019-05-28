# *********************************************************************
# SVILUPPATA DA FRANCESCO LORETI
# *********************************************************************
class ExtraFormWith < ActionView::Helpers::FormBuilder

	TEXT_FORM_HELPERS     = %w{text_field number_field password_field email_field telephone_field text_area search_field color_field, coord_field}
	TEXTAREA_FORM_HELPERS = %w{textarea tinymce}
	DATETIME_FORM_HELPERS = %w{date_time_field date_field time_field}
	CHECKBOX_FORM_HELPERS = %w{check_box_field boolean_field}
	RADIO_FORM_HELPERS    = %w{radio_button_field}

	delegate :content_tag, to: :@template
	delegate :label_tag, to: :@template

	TEXT_FORM_HELPERS.each do |method_name|
		define_method(method_name) do |method, *args|
			options = args.extract_options!.symbolize_keys!
			text_tag("#{__method__.to_s}", method, options: options ).html_safe
		end
		# Methods with condition
		define_method("#{method_name}_if") do |condition, method, *args|
			options = args.extract_options!.symbolize_keys!
			type = "#{__method__.to_s}".gsub('_if', '')
			if condition
				text_tag(type, method, options: options ).html_safe
			else
				label_field( method, options: options )
			end
		end
	end

	TEXTAREA_FORM_HELPERS.each do |method_name|
		define_method(method_name) do |method, *args|
			options = args.extract_options!.symbolize_keys!
			text_area("#{__method__.to_s}", method, options).html_safe
		end
		# Methods with condition
		define_method("#{method_name}_if") do |condition, method, *args|
			options = args.extract_options!.symbolize_keys!
			type = "#{__method__.to_s}".gsub('_if', '')
			if condition
				text_area(type, method, options).html_safe
			else
				label_field( method, options: options )
			end
		end
	end

	DATETIME_FORM_HELPERS.each do |method_name|
		define_method(method_name) do |method, *args|
			options = args.extract_options!.symbolize_keys!
			datetime_field("#{__method__.to_s}", method, options: options).html_safe
		end
		# Methods with condition
		define_method("#{method_name}_if") do |condition, method, *args|
			options = args.extract_options!.symbolize_keys!
			type = "#{__method__.to_s}".gsub('_if', '')
			if condition
				datetime_field(type, method, options: options).html_safe
			else
				label_field( method, options: options )
			end
		end
	end

	CHECKBOX_FORM_HELPERS.each do |method_name|
		define_method(method_name) do |method, *args|
			options = args.extract_options!.symbolize_keys!
			check_box("#{__method__.to_s}", options: options ).html_safe
		end
		# Methods with condition
		define_method("#{method_name}_if") do |condition, method, *args|
			options = args.extract_options!.symbolize_keys!
			if condition
				check_box(method, options, true, false ).html_safe
			else
				check_box(method, options.merge( disabled:'disabled', class: 'disabled right', data: { tooltip: true, disable_hover:'false' }, aria: { haspopup: 'true' } ), true, false).html_safe
			end
		end
	end

	RADIO_FORM_HELPERS.each do |method_name|
		define_method(method_name) do |method, *args|
			options = args.extract_options!.symbolize_keys!
			radio_button_field("#{__method__.to_s}", options: options ).html_safe
		end
		# Methods with condition
		define_method("#{method_name}_if") do |condition, method, *args|
			options = args.extract_options!.symbolize_keys!
			type = "#{__method__.to_s}".gsub('_if', '')
			if condition
				radio_button_field( method, options: options ).html_safe
			else
				label_field( method, options: options )
			end
		end
	end

	def error_tag( errors: '' )
		content_tag( :small, errors, class: "error" ) unless errors.blank?
	end

	def helper_tag( help_text: '' )
		content_tag( :small, help_text, class: "help-text" ) unless help_text.blank?
	end

	def help_tag( object_name: '', method: '', type: '', value: '' )
		title = []
		title << "#{ I18n.t( method.to_s, scope: [ 'help', object_name.try(:pluralize), 'fields' ], default: '' ) }" unless method.blank?
		title << case type
			when 'number_field'; "( 0..9 )"
			when 'email_field'; "( a..z @ . )"
			when 'datetime_field'; "( gg-mm-YYYY HH:MM)"
			when 'date_field'; "( gg-mm-YYYY )"
			when 'time_field'; "( HH:MM )"
			else; ''
		end
		title << value unless value.blank?
		unless title.join('').blank?
			content_tag :span do
				content_tag :i, '', title: title.join(''), class: "fa fa-question-circle text-primary has-tip"
			end
		else
			''
		end
	end

	def warning_tag( object_name: '', method: '', type: '', value: '' )
		title = []
		title << "#{ I18n.t( method.to_s, scope: [ 'warning', object_name.try(:pluralize), 'fields' ], default: '' ) }" unless method.blank?
		title << value unless value.blank?
		unless title.join('').blank?
			content_tag :span do
				content_tag :i, '', title: title.join(''), class: "fa fa-exclamation-circle text-alert has-tip"
			end
		else
			''
		end
	end

	def icon_tag( icon: '', valign: 'middle' )
		valign = "valign-#{ valign }"
		unless icon.blank?
			content_tag :span, class: "input-group-label #{ valign }" do
				content_tag :i, '', class: "fa fa-#{ icon }"
			end
		end
	end

	def coord_tag( text: '', valign: 'middle' )
		valign = "valign-#{ valign }"
		unless text.blank?
			content_tag :span, text, class: "input-group-label text-center #{ valign }" 
		end
	end

	def submit_button( value: nil, icon: nil, options: {}, confirm: false )
		content = []
		content << content_tag( :i, '', class: "fa fa-#{ icon }" ) unless icon.blank?
		if value.blank?
			content << ( @object.new_record? ? I18n.t( 'create', scope: '', default: "Create".humanize ) : I18n.t( 'update', scope: '', default: "Update".humanize ) )
			content << I18n.t( 'title', scope: [ object_name.pluralize ], default: object_name.humanize ) unless options[:label] == 'false'
		else
			content << value
		end
		if options.present? && options[:name].present?
			tag = content_tag :button, content.join(' ').html_safe, type: 'submit', name: options[:name], data: { disable_with: "<i class='fa fa-spinner fa-pulse'></i> #{ I18n.t('wait', default: "Wait please..." ) }".html_safe, confirm: confirm }, class: "button extended #{options[:button_class]}"
		else
			tag = content_tag :button, content.join(' ').html_safe, type: 'submit', disabled: options.present? && options[:disabled].present? ? options[:disabled] : false, data: { disable_with: options[:disable_with].present? ? options[:disable_with] : "<i class='fa fa-spinner fa-pulse'></i> #{ I18n.t('wait', default: "Wait please..." ) }".html_safe, confirm: confirm }, class: "button extended #{ options[:class] if options.present? && options[:class].present? }"
		end
		if options[:content] == 'false'
			tag
		else
			content_tag :div, '', class: 'small-12 large-6 float-center cell text-center' do
				tag
			end
		end
	end

	def search_button( options )
		icon = content_tag :i, '', class: "fa fa-search"
		content_tag :div, '', class: 'input-group-button' do
			content_tag :button, icon.html_safe, data: { disable_with: "<i class='fa fa-spinner fa-pulse'></i>".html_safe }, class: 'button'
		end
	end

	def remove_button( options, method )
		icon = content_tag :i, '', class: "fa fa-trash"
		content_tag :div, '', class: 'input-group-button' do
			request_path = @template.request.path
			query_hash = @template.params.except(object_name, :controller, :action, :utf8).to_unsafe_h
			url = "#{request_path}#{'?'+query_hash.to_query unless query_hash.blank?}"
			content_tag :a, icon.html_safe, href: url, data: { disable_with: "<i class='fa fa-spinner fa-pulse'></i>".html_safe }, class: 'button alert text-middle'
		end
	end

	def text_tag(type, method, options: {})
		init_options( method, options )
		errors = @object.errors[method].join(', ') unless @object.blank? || @object.errors.blank? || @object.errors[method].blank?
	
		content = ''
		type_tag = type == 'coord_field' ? 'number_field_tag' : type+'_tag'
		content << icon_tag( icon: options[:icon], valign: options[:valign] ) unless options[:icon].blank?
		content << @template.send(type_tag, "#{object_name}[#{method}]", options[:value], required: options[:required_tag], autocomplete: options[:autocomplete], min: options[:min], max: options[:max], step: options[:step], maxlength: options[:maxlength], placeholder: options[:placeholder], :class => "input-group-field #{options[:required_class]} #{options[:class]}#{ 'text-right' if type_tag == 'number_field_tag' } #{ 'invalid' if @object.present? && @object.persisted? && @object.errors.include?(method) }")
		content << coord_tag( text: options[:post_text] ) if type == 'coord_field'
		content << search_button( options ) if type == 'search_field'
		content << remove_button( options, method ) if type == 'search_field' && ( options[:remove_button] == 'true' && options[:value].present? )
		
		content_tag :div, class: "#{ options[:inline] ? 'input-inline' : 'input' } #{options[:icon]} #{options[:required_class]} #{object_name}_#{method}" do
			"#{ label( object_name, options, method, type ) }  
			#{ content_tag( :div, content.try(:html_safe), class: 'input-group' ) } 
			#{ helper_tag( help_text: options[:help_text] ) } 
			#{ error_tag( errors: errors ) }".html_safe
		end
	end

	def radio_button_field( method, choices = nil, options: {} )
		init_options( method, options )
		errors = @object.errors[method].join(', ') unless @object.blank? || @object.errors.blank? || @object.errors[method].blank?
		content = ''
		choices.each do | k,v |
			radio = "<div class='grid-x  grid-padding-x'>"
			radio << @template.send( 'radio_button_tag', "#{object_name}[#{method}]", v, options[:selected] == v, id: "#{object_name}_#{method}_#{v}", class: 'small-1 cell' )
			radio << " " + content_tag( :label, k, for: "#{object_name}_#{method}_#{v}", class: "auto cell" )
			radio << "</div>"
			content << content_tag( :div, radio.try(:html_safe), class: 'cell' )
		end
		
		content_tag :div, class: "cell #{ options[:inline] ? 'input-inline' : 'input' }" do
			"#{ label( object_name, options, method, 'radio_button' ) } 
			#{ content_tag( :div, content.try(:html_safe), class: 'grid-x grid-margin-x grid-padding-x' ) } 
			#{ error_tag( errors: errors ) }".html_safe
		end
	end

	def file_field( method, options: {} )
		init_options( method, options )
		errors = @object.errors[method].join(', ') unless @object.blank? || @object.errors.blank? || @object.errors[method].blank?

		content = ''
		content << icon_tag( icon: options[:icon], valign: options[:valign] ) unless options[:icon].blank?
		content << @template.send('file_field_tag', "#{object_name}[#{method}]", value: options[:value], :class => "input-group-field #{options[:required_class]} #{options[:class]} #{ 'invalid' if @object.present? && @object.persisted? && @object.errors.include?(method) }")
	
		content_tag :div, class: "#{ options[:inline] ? 'input-inline' : 'input' } #{options[:icon]} #{options[:required_class]} #{object_name}_#{method}" do
			"#{ label( object_name, options, method, 'file_field' ) unless options[:label] == 'false' } 
			#{ content_tag( :div, content.try(:html_safe), class: 'input-group' ) } 
			#{ error_tag( errors: errors ) }".html_safe
		end
	end

	def label_field( method, options: {} )
		init_options( method, options )
		
		content = ''
		content << icon_tag( icon: options[:icon], valign: options[:valign] ) unless options[:icon].blank?
		content << content_tag( :div, options[:placeholder], class: "input-group-field label_field #{options[:required_class]} #{options[:class]} " )

		content_tag :div, class: "#{ options[:inline] ? 'input-inline' : 'input' } #{options[:icon]} #{options[:required_class]} #{object_name}_#{method}" do
			"#{ label( object_name, options, method, 'label_field' ) }  
			#{ content_tag( :div, content.html_safe, class: 'input-group' ) }".html_safe
		end
	end

	def select_field(method, choices = nil, options = {}, html_options = {}, &block)
		init_options( method, options )
		options[:selected] ||= @object.send(method) || 0
		errors = @object.errors[method].join(', ') unless @object.blank? && @object.errors.blank? && @object.errors[method].blank?		
		content = ''
		content << icon_tag( icon: options[:icon], valign: options[:valign] ) unless options[:icon].blank?
		content << @template.select(@object_name, method, choices, objectify_options(options), @default_options.merge(html_options), &block)

		content_tag :div, class: "#{ options[:inline] ? 'input-inline' : 'input' } #{options[:icon]} #{options[:required_class]} #{object_name}_#{method}" do
			"#{ label( object_name, options, method, 'select_field' ) unless options[:label] == 'false' }  
			#{ content_tag( :div, content.html_safe, class: "input-group #{ html_options[:multiple] }" ) } 
			#{ error_tag( errors: errors ) }".html_safe
		end

	end

	def select_field_if(condition, method, choices = nil, options: {}, input_options: {}, &block)
		if condition
			select_field(method, choices, options, input_options, &block)
		else
			# options[:value] = options[:alt_value]
			label_field( method, options: options )
		end
	end

	def boolean_field( method, options = {} )
		init_options( method, options )
		content = ''
		content << check_box( method, options, "true", "false" )
		content << label( object_name, options, method, 'boolean_field' ) unless options[:label] == 'false'
		return content.html_safe
	end

	def datetime_field( type, method, options: {} )
		init_options( method, options )
		errors = @object.errors[method].join(', ') unless @object.blank? || @object.errors.blank? || @object.errors[method].blank?
		options[:year_start] ||= DateTime.now.year-2.years
		options[:year_stop] ||= DateTime.now.year+1.years

		content = ''
		content << icon_tag( icon: options[:icon], valign: options[:valign] ) unless options[:icon].blank?
		content << @template.send('text_field_tag', "#{object_name}[#{method}]", options[:value].blank? ? '' : I18n.l( options[:value], format: :default ), :class => "input-group-field #{options[:class]} #{ type } #{ 'invalid' if @object.present? && @object.persisted? && @object.errors.include?(method) }", autocomplete: "off")

		content_tag :div, class: "#{ options[:inline] ? 'input-inline' : 'input' } #{options[:icon]} #{options[:required_class]} #{object_name}_#{method}" do
			"#{ label( object_name, options, method, type ) }  
			#{ content_tag( :div, content.html_safe, class: 'input-group' ) } 
			#{ error_tag( errors: errors ) }".html_safe
		end
	end

	def text_area( type, method, options = {} )
		init_options( method, options )
		errors = @object.errors[method].join(', ') unless @object.blank? || @object.errors.blank? || @object.errors[method].blank?
		content = ''
		content << icon_tag( icon: options[:icon], valign: options[:valign] ) unless options[:icon].blank?
		content << @template.send('text_area_tag', "#{object_name}[#{method}]", options[:value], required: options[:required_tag], :class => "input-group-field #{ type } #{options[:required_class]} #{options[:class]} #{ 'invalid' if @object.present? && @object.persisted? && @object.errors.include?(method) }")

		content_tag :div, class: "#{ options[:inline] ? 'input-inline' : 'input' } #{options[:icon]} #{options[:required_class]} #{object_name}_#{method}" do
			"#{ label( object_name, options, method, type ) } 
			#{ content_tag( :div, content.html_safe, class: 'input-group' ) } 
			#{ error_tag( errors: errors ) }".html_safe
		end
	end

	def switch_field( method, options = {} )
		init_options( method, options )
		errors = @object.errors[method].join(', ') unless @object.blank? || @object.errors.blank? || @object.errors[method].blank?
		content = ''
		content << icon_tag( icon: options[:icon], valign: options[:valign] ) unless options[:icon].blank?
		content << boolean_field( method, options.merge(label: 'false') )
		content << content_tag( :label, class: "switch-paddle", for: "#{object_name}_#{method}" ) do
			"<span class='switch-active' aria-hidden='true'>#{ I18n.t("yes") }</span>
			 <span class='switch-inactive' aria-hidden='true'>#{ I18n.t("no") }</span>".html_safe
		end
    content_tag :div, class: "switch large #{ options[:inline] ? 'input-inline' : 'input' } #{options[:icon]} #{options[:required_class]} #{object_name}_#{method}" do
			"#{ label( object_name, options, method, 'switch_field' ) } 
			#{ content_tag( :div, content.html_safe, class: 'input-group' ) } 
			#{ error_tag( errors: errors ) }".html_safe
		end
	end

	private
		def init_options( method, options= {} )
			unless @object.blank?
				options[:value] ||= @object.send(method)
				options[:required] ||= @object.class.validators_on(method).map(&:class).include?( ActiveRecord::Validations::PresenceValidator )
				options[:checked] ||= @object.send(method)
			end
			options[:help_text] ||= ''
			options[:warning_text] ||= ''
			options[:required_class] ||= ( options[:required] == true ? 'required' : 'optional' )
			options[:required_tag] == 'required' ? 'required' : false
			options[:inline] ||= false
			options[:id] ||= "#{object_name}_#{method}"
		end

		def label( object_name, options, method, type = '')
			unless options[:label] == 'false'
				options[:label] ||= I18n.t( method.to_s, scope: [ object_name.try(:pluralize), 'fields' ], default: "#{method.to_s}".humanize )   #"#{method.to_s}".humanize
				class_html = []
				class_html << options[:icon] unless options[:icon].blank?
				# class_html << options[:required_class]
				class_html << options[:label_class]
				# class_html << 'invalid' if options[:required] == true && @object.invalid? && @object.persisted?

				content = ''
				content += content_tag( :abbr, '*', title: I18n.t( 'required' ) ) if options[:required] == true
				content += " #{ options[:label] } "
				content += help_tag( object_name: object_name, method: method, type: type, value: options[:help_text] ) unless options[:help] == false
				content += warning_tag( object_name: object_name, method: method, type: type, value: options[:warning_text] ) unless options[:warning] == false

				content_tag :label, content.html_safe, class: class_html.join(' ').to_s, for: "#{object_name}_#{method}"
			end
		end
end