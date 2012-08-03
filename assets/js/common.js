$(document).ready(function() {
	var $root = $('#header > a').attr('href'),
		$body = $('body');
	
	/*------------------------------------------------------------------
		Fixes for Internet Explorer
	------------------------------------------------------------------*/
		
		if ($.browser.msie) {
			if($.browser.version <= 9) {

			}
			if($.browser.version <= 8) {

			}
		}

	/*------------------------------------------------------------------
		Open external links in a new tab/window
	------------------------------------------------------------------*/

		$body.on('click', 'a.external, a[rel=external]', function() {
			var self = $(this);
			
			if($.browser.msie & self.attr('href').search(/.pdf$/) != -1) return true;

			window.open(self.attr('href'));
			return false;
		});

});
