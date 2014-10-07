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
			next: '.slider-testimonial-small .slider-next'
		});

		// Slider Office
		$('.slider-office .slides').carouFredSel({
			scroll : { fx : "fade" },
			pagination: {
				container: '.slider-office .slider-paging ul',
				anchorBuilder: function(number) {
				return '<li><a href="#' + number + '">'+ number +'</a></li>';
				}
			}
		});

		// Slider Bios
		function changeBio(direction){
			var $currentBio = $('.section-current');

			$currentBio.removeClass('section-current').addClass('section-hidden').hide();
	
			if(direction === 'forward'){

					$currentBio.next().fadeIn('slow').removeClass('section-hidden').addClass('section-current');
					$currentBio.detach().appendTo('.bio-paragraphs');

			} else {

					$('.bio-paragraphs').find('.section').last()
						.detach().prependTo('.bio-paragraphs').fadeIn('slow')
							.removeClass('section-hidden').addClass('section-current');
			}
		}

		function changeSlide(direction) {
			event.preventDefault();

			var $currentImage = $('.slider-team').find('.current');
			var $lastSlide = $('.slider-team').find('.slide').last();

			$currentImage.removeClass('current');

			if(direction === 'forward'){

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

					changeBio('previous');
			}
		}

		var $prev = $('.slider-prev');
		var $next = $('.slider-next');

		$next.click(function(event){
			changeSlide('forward');
		});

		$prev.click(function(event){
			changeSlide('backward');
		});

		// Home Page to Links to Accordion Tabs
		// var htmlID;
		// if(htmlID !== null){
		// 	$(htmlID).trigger('click');
		// }

		// $('.therapy-items').on('click', 'a', function(event){
		// 	event.preventDefault();

		// 	console.log('Click registered!');

		// 	console.log(event.currentTarget);
			
		// 	var fullPath = $(event.currentTarget).attr('href');
		// 	console.log('Path is: ' + fullPath);

		// 	var index = fullPath.indexOf('#');
		// 	console.log('Index is: ' + index);

		// 	htmlID = fullPath.substring(index);
		// 	console.log('HTML ID is: ' + htmlID);

		// 	var shortPath = fullPath.substring(1, index);
		// 	console.log('Short path is: ' + shortPath);

		// 	window.location.pathname = shortPath;
		//  Need a way to pass param to URL:  encodeURI and encodeURIComponent are not working
		// 	Would then need a regexp to parse the window.location.href, grab the param, and trigger the JQuery below

		// });

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
