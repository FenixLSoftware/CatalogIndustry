$(function () {
    /* demo highchart */
    if ($('#chart1').length > 0) {
        Highcharts.chart('chart1', {
            title: {
                text: ''
            },
            yAxis: {
                title: {
                    text: 'Number of Employees'
                }
            },
            legend: {
                enabled: false
            },
            plotOptions: {
                series: {
                    pointStart: 2010
                }
            },
            series: [{
                name: 'Installation',
                data: [43934, 52503, 57177, 69658, 97031, 119931, 137133, 154175]
            }]
        });
    }

    $('.showExpand').on('click', function (e) {
        e.preventDefault();
        var $item = $(this).closest('.products_item'),
            $productExpand = $item.find('.product_expand'),
            expandHeight = $productExpand.outerHeight(),
            oldHeight = $item.outerHeight(),
            newHeight = expandHeight + oldHeight + 50,
            positionLeft = $item.position().left;
        if (!$item.hasClass('is_open')) {
            $('.products_item').attr('style', '').removeClass('is_open');
            $('.product_expand').hide();
            $productExpand.show();
            $productExpand.find('.product_expand_container_arrow').css({'left': positionLeft + 'px'});
            $item.css({height: newHeight + 'px'}).addClass('is_open');
        } else {
            $productExpand.hide();
            $item.attr('style', '').removeClass('is_open');
        }
    });

    $('.hideExpand').on('click', function (e) {
        e.preventDefault();
        var $item = $(this).closest('.products_item'),
            $productExpand = $item.find('.product_expand');
        $productExpand.hide();
        $item.attr('style', '').removeClass('is_open');
    });

    $('.openMore').on('click', function (e) {
        e.preventDefault();
        var $parent = $(this).closest('.more');
        $parent.toggleClass('active');
        $(this).find('span').toggleClass('hidden');
    });

    $('.modal_close').on('click', function(e){
      e.preventDefault();
      $(this).closest('.modal').removeClass('active');
    });
});
