;(function($, window, document, undefined) {
	var $win = $(window);
	var $doc = $(document);

	$doc.ready(function() {
		// Fullscreener
		$('.footer-background img').fullscreener();
		$('.intro-image img').fullscreener();
		$('.map img').fullscreener();

		// Slider Testimonials
		$('.slider-testimonials .slides').carouFredSel({
			scroll : { fx : "fade" },
			pagination: {
				container: '.slider-testimonials .slider-paging ul',
				anchorBuilder: function(number) {
				return '<li><a href="#' + number + '">'+ number +'</a></li>';
				}
			}
		});

		// Slider Testimonials Small
		$('.slider-testimonial-small .slides').carouFredSel({
			prev: '.slider-testimonial-small .slider-prev',
			next: '.slider-testimonial-small .slider-next',
			auto: 5000,
			scroll: { duration: 1000 }
		});

		// Slider Office
		$win.load(function(){
			$('.slider-office .slides').carouFredSel({
				scroll : { fx : "fade" },
				pagination: {
					container: '.slider-office .slider-paging ul',
					anchorBuilder: function(number) {
					return '<li><a href="#' + number + '">'+ number +'</a></li>';
					}
				}
			});
		});

		// Slider Staff Bios
		function highlightSlide(event){
			var $highlightedSlide = $('.slider-team').find('.current');
			$highlightedSlide.removeClass('current');
			$(event.currentTarget).addClass('current');
		}

		function changeBio(selection){
			var $currentBio = $('.section-current');
			$currentBio.removeClass('section-current')
				.addClass('section-hidden').hide();
	
			if(selection === 'forward'){
				$currentBio.next().fadeIn('slow')
					.removeClass('section-hidden').addClass('section-current');
					
				$('.bio-paragraphs').find('.section').first().detach()
					.appendTo('.bio-paragraphs');
			} 
		  else if(selection === 'backward'){
				$('.bio-paragraphs').find('.section').last().detach()
					.prependTo('.bio-paragraphs');

				$currentBio.prev().fadeIn('slow').removeClass('section-hidden')
					.addClass('section-current');
			}
			else {
				var $selectedSlide = $(selection.currentTarget);

				//  JQuery indexes are 0-based but CSS indexes are 1-based
				var position = $('.slider-team').find('.slide')
					.index($selectedSlide) + 1;

				var $newBio = $('.bio-paragraphs')
					.find('section:nth-of-type(' + position + ')');

				$newBio.fadeIn('slow').removeClass('section-hidden')
					.addClass('section-current');
			}
		}

		function changeSlide(selection) {
			event.preventDefault();
			var $currentSlide = $('.slider-team').find('.current');
			var $lastSlide = $('.slider-team').find('.slide').last();

			$currentSlide.removeClass('current');

			if(selection === 'forward'){
				$currentSlide.next().addClass('current');
				$('.slider-team').find('.slide').first().addClass('staff-hidden')
					.detach().appendTo('.slides');

				$lastSlide.prev().removeClass('staff-hidden');

				changeBio('forward');
			} 
			else {
					var $teamSlides = $('.slider-team').find('.slides');
			
					// Find the last displayed slide and hide it
					$lastSlide.prev().prev().addClass('staff-hidden');
					$lastSlide.detach().prependTo($teamSlides)
						.removeClass('staff-hidden');

					$currentSlide.prev().addClass('current');

					changeBio('backward');
			}
		}

		var $prev = $('.slider-prev');
		var $next = $('.slider-next');

		$('.slider-team').find('.slide').click(function(event){
			highlightSlide(event);
			changeBio(event);
		});

		$next.click(function(event){
			changeSlide('forward');
		});

		$prev.click(function(event){
			changeSlide('backward');
		});

		// Accordion Therapy
		(function(){
			// This class will be added to the expanded item
			var activeItemClass = 'accordion-expanded';
			var accordionItemSelector = '.accordion-section';
			var toggleSelector = '.accordion-head';
			var $accordionBody = $('.accordion-head').next();
		 
			$(toggleSelector).on('click', function(e) {
		 
				$(this).next().slideToggle();

				if($accordionBody.is(":visible")) {
					$(this).children('.btn-plus').toggleClass('btn-minus');
				} 

				event.preventDefault();
			});
		 
		})();
	});
})(jQuery, window, document);
