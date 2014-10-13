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
			$('.section-team').attr('data-need-revert', true);

			var $highlightedSlide = $('.slider-team').find('.current');
			$highlightedSlide.removeClass('current');

			$(event.currentTarget).addClass('current');
		}

		function unhighlightSlide(){
			var $highlightedSlide = $('.slider-team').find('.current');
			$highlightedSlide.removeClass('current');

			$('.slider-team').find('.slide').first()
				.addClass('current');

			changeBio('revert');
			/*	
				Reverts slides to their original "order"
				so that the changeSlide() function still
				works properly.  The order of the DOM is
				not being actually changed, only the classes
				of the elements so that first bio is highlighted.
			*/
		}

		function changeBio(selection){
			var $currentBio = $('.section-current');
			$currentBio.removeClass('section-current')
				.addClass('section-hidden').hide();
	
			if(selection === 'forward'){
					$currentBio.next().fadeIn('slow')
						.removeClass('section-hidden').addClass('section-current');
					$currentBio.detach().appendTo('.bio-paragraphs');

			} 
		  else if(selection === 'backward'){
					$('.bio-paragraphs').find('.section').last()
						.detach().prependTo('.bio-paragraphs').fadeIn('slow')
							.removeClass('section-hidden').addClass('section-current');
			}
			else if(selection === 'revert'){
				$('.bio-paragraphs').find('.section').first()
					.fadeIn('slow').removeClass('section-hidden')
						.addClass('section-current');
			}
			else {
				var $selectedSlide = $(selection.currentTarget);
				var position = $('.slider-team')
					.find('.slide').index($selectedSlide) + 1;
				/*  
					Must add 1 because JQuery indexes are 0-based,
			    but CSS indexes are 1-based and we use the CSS
				  psuedo-selector :nth-of-type below.
				*/

				var $newBio = $('.bio-paragraphs')
					.find('section:nth-of-type(' + position + ')');

				$newBio.fadeIn('slow').removeClass('section-hidden')
					.addClass('section-current');
			}
		}

		function changeSlide(selection) {
			event.preventDefault();

			var $currentImage = $('.slider-team').find('.current');
			var $lastSlide = $('.slider-team').find('.slide').last();

			$currentImage.removeClass('current');

			if(selection === 'forward'){
				$currentImage.next().addClass('current');
				$currentImage.addClass('staff-hidden').detach().appendTo('.slides');
				$lastSlide.prev().removeClass('staff-hidden');

				changeBio('forward');

			} else {
					var $teamSlides = $('.slider-team').find('.slides');
			
					// Find the last displayed slide and hide it
					$lastSlide.prev().prev().addClass('staff-hidden');

					$lastSlide.removeClass('staff-hidden').addClass('current')
						.detach().prependTo($teamSlides);

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
			if( $('.section-team').data('need-revert') === true ){
				unhighlightSlide();
			}
			changeSlide('forward');
		});

		$prev.click(function(event){
			if( $('.section-team').data('need-revert') === true ){
				unhighlightSlide();
			}
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
