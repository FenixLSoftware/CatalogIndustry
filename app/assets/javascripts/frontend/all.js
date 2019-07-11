$(function () {

    if ($('#flexslider_hero').length > 0) {
        $('#flexslider_hero').flexslider({
            directionNav: false,
            controlNav: true
        });
    }

    if ($('#flexslider_product').length > 0) {
        $('#flexslider_product_thumbs').flexslider({
            animation: "slide",
            controlNav: false,
            animationLoop: false,
            slideshow: false,
            itemWidth: 210,
            itemMargin: 5,
            asNavFor: '#flexslider_product'
        });

        $('#flexslider_product').flexslider({
            animation: "fade",
            controlNav: false,
            directionNav: false,
            animationLoop: false,
            slideshow: false,
            sync: "#flexslider_product_thumbs"
        });
    }

    if ($('#products_grid-masonry').length > 0) {
        $('#products_grid-masonry').masonry({
            itemSelector: '.products_item',
            columnWidth: '.products_item',
            percentPosition: true
        });
    }

    if ($(document).width() > 767) {
        if ($('#categories_grid-masonry').length > 0) {
            $('#categories_grid-masonry').masonry({
                itemSelector: '.categories_block',
                columnWidth: '.categories_block',
                percentPosition: true
            });
        }
    }



    $('#products_grid-masonry').masonry({
        itemSelector : '.products_item'
    });



    $('#openSearch').on('click', function (e) {
        e.preventDefault();
        $('#mSearch').toggleClass('active');
    });

    $('#openMenu').on('click', function (e) {
        e.preventDefault();
        $('#menu').toggleClass('active');
        $(this).find('.fa').toggleClass('hidden');
    });

    $('.openLogin').on('click', function (e) {
        e.preventDefault();
        $('#mLogin').addClass('active');
        $('body').append('<a class="overlay" href="#"></a>');
    });


    $('#openRecovery').on('click', function (e) {
        e.preventDefault();
        $('#mLogin').removeClass('active');
        $('#mRecovery').addClass('active');
        $('body').append('<a class="overlay" href="#"></a>');
    });

    $('.closeModal').on('click', function (e) {
        e.preventDefault();
        var $modal = $(this).closest('.modal');
        $modal.removeClass('active');
        $('a.overlay').remove();
    });

    $('body').on('click', 'a.overlay', function (e) {
        e.preventDefault();
        $('.modal').removeClass('active');
        $('a.overlay').remove();
    });

    $('form input, form textarea').on('focusout', function (e) {
        if ($(this).val() != '') {
            $(this).addClass('full');
        } else {
            $(this).removeClass('full');
        }
    });

    $('.select select').on('change', function (e) {
        if ($(this).val() != '') {
            $(this).closest('.select').addClass('full');
        } else {
            $(this).closest('.select').removeClass('full');
        }
    });

    $('#openMore').on('click', function (e) {
        e.preventDefault();
        var $parent = $(this).closest('.more');
        $parent.toggleClass('active');
        $(this).find('span').toggleClass('hidden');
    });





    // $('.tabs_menu a').on('click', function(e){
    //   e.preventDefault();
    //   var $li = $(this).closest('li'),
    //       index = $li.index(),
    //       $tabs = $(this).closest('.tabs');
    //   $tabs.find('.tabs_menu li').removeClass('active');
    //   $tabs.find('.tabs_menu li').eq(index).addClass('active');
    //   $tabs.find('.tabs_content').removeClass('active');
    //   $tabs.find('.tabs_content').eq(index).addClass('active');
    // });

});
