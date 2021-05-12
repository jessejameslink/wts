$(function() {
	/* main banner slide */
	if($('.main_banner_wrap').length) {
		$('.main_banner_wrap').slidesjs({
			width: 1100,
			height: 220,
			pagination: {
				active: false
			},
			navigation: {
				effect: 'slide'
			},
			effect: {
				slide: {
					speed: 1000
				},
				fade: {
					speed: 800
				}
			}
		});
	}

	/* datepicker */
	$('.datepicker').each(function() {
		var self = $(this);

		self.datepicker({
			changeYear:true,
			changeMonth:true,
			dateFormat  : "dd/mm/yy"
		});

		self.next('button').on('click', function() {
			self.datepicker('show');
		});
	});

	/* tab */
	$('.tab_container').each(function() {
		var links = $(this).find('.tab a'),
			conts = $(this).find('.tab_conts > div');

		links.on('click', function(e) {
			var id = $(this).attr('href');

			links.removeClass('on');
			conts.removeClass('on');

			$(this).addClass('on');
			conts.filter(id).addClass('on');

			e.preventDefault();
		});
		links.eq(0).trigger('click');
	});

	/* layer popup */
	window.openLayerPop = function(id) {
		$('.layer_pop').hide();
		$(id).css({height: $(document).height()}).show();
	}

	window.closeLayerPop = function(id) {
		if(id) {
			$(id).hide();
		} else {
			$('.layer_pop').hide();
		}
	}

	$('.open_layer').on('click', function(e) {
		var id = $(this).attr('href');
		openLayerPop(id);
		e.preventDefault();
	});

	$(document).on('click', '.btn_close_pop', function(e) {
		closeLayerPop();
		e.preventDefault();
	});

	/* scroll to top */
	$('.btn_top a').on('click', function(e){
		$('html, body').animate({scrollTop : 0}, 200);
		e.preventDefault();
	});
	
	
	
	
	
});