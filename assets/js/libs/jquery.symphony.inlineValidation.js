(function($) {
	$.fn.SymphonyInlineValidation = function(o) {
		o = $.extend({

			validate: ".label:contains('*') + input:not(:hidden),.label:contains('*') + textarea:not(:hidden) ",
			canofspam: false,
			url: null

		}, o || {});

		return this.each(function() {
			if(o.url == null) return false;

			var self = $(this);

			/*	Only validate fields that are required, using the form builder is defined as the label containing a * */
			var fields = $('input, textarea', self).filter(o.validate);

			/*	Show message only after user has passed over the field and stuffed up */
			fields.blur(function() {
				var field = $(this);

				/*	Just send this field, otherwise if all the fields are correct an entry would
				**	be made in Symphony */
				var post = field.serializeArray();

				/*	Without canofspam, the request fails without any detailed field information. */
				if(o.canofspam) {
					var can = [{name: "canofspam", value: $('input[name=canofspam]').val()}];

					post = jQuery.merge(post,can);
				}

				/*	Without the submit action, the validation page doesn't know what event to process */
				var action = [
						{name: self.find('[name^=action]').attr("name")}
					];

				var send = jQuery.merge(post,action);

				$.post(o.url, send,
					function(data) {
						doInlineValidation(data)
					}, "xml"
				);

				function doInlineValidation(data) {
					/*	Needs fields[{name}] syntax for Symphony, but for the validation, we just want the
					**	{name}, so replace the fields[ and slice off the end ] (could be done better) */
					var name = field.attr('name').replace(/fields\[/, "").slice(0,-1);
					var invalid = $(data).find(name + "[message]");

					//var target = field.prev('.information');
					//var target = field.prev('.information');
					var target = field.parent();
					
					
					/*	If there's a message for this field, it will always be bad,
					**	show it to the user */
					if(invalid.length == 1 ) {
						/*	Allows you to alias form fields are the field's label */
						var label = $('label',field.parent()).text();
						/*	Again, my RegExp fu is low, this could be better */
						var reg = new RegExp(name, "i");

						var msg = invalid.attr("message").replace(reg, label).replace(/\*/,"");
						if(invalid.attr("type") == 'invalid') {
							var msg = '\'' + label.slice(0,-1) + '\' contains invalid data.';
						} else {
							var msg = invalid.attr("message").replace(reg, label).replace(/\*/,"");
						}
						
						if(target.find('.error').length == 0) {
							target.addClass('error').append("<span class='error'>" + msg + "</span>").slideDown("fast");
						} else if(target.find('.error').text() != msg) {
							target.addClass('error').find('.error').text(msg).slideDown("fast");
						}

					} else {
						target.removeClass('error').find('.error').slideUp("fast", function() {
							$(this).empty();
						});
					}
				}
			});
		});
	};
})(jQuery);