$(function(){0<$("#flexslider_hero").length&&$("#flexslider_hero").flexslider({directionNav:!1,controlNav:!0}),0<$("#flexslider_product").length&&($("#flexslider_product_thumbs").flexslider({animation:"slide",controlNav:!1,animationLoop:!1,slideshow:!1,itemWidth:210,itemMargin:5,asNavFor:"#flexslider_product"}),$("#flexslider_product").flexslider({animation:"fade",controlNav:!1,directionNav:!1,animationLoop:!1,slideshow:!1,sync:"#flexslider_product_thumbs"})),0<$("#products_grid-masonry").length&&$("#products_grid-masonry").masonry({itemSelector:".products_item",columnWidth:".products_item",percentPosition:!0}),767<$(document).width()&&0<$("#categories_grid-masonry").length&&$("#categories_grid-masonry").masonry({itemSelector:".categories_block",columnWidth:".categories_block",percentPosition:!0}),$("#products_grid-masonry").masonry({itemSelector:".products_item"}),$("#openSearch").on("click",function(e){e.preventDefault(),$("#mSearch").toggleClass("active")}),$("#openMenu").on("click",function(e){e.preventDefault(),$("#menu").toggleClass("active"),$(this).find(".fa").toggleClass("hidden")}),$(".openLogin").on("click",function(e){e.preventDefault(),$("#mLogin").addClass("active"),$("body").append('<a class="overlay" href="#"></a>')}),$("#openRecovery").on("click",function(e){e.preventDefault(),$("#mLogin").removeClass("active"),$("#mRecovery").addClass("active"),$("body").append('<a class="overlay" href="#"></a>')}),$(".closeModal").on("click",function(e){e.preventDefault(),$(this).closest(".modal").removeClass("active"),$("a.overlay").remove()}),$("body").on("click","a.overlay",function(e){e.preventDefault(),$(".modal").removeClass("active"),$("a.overlay").remove()}),$("form input, form textarea").on("focusout",function(){""!=$(this).val()?$(this).addClass("full"):$(this).removeClass("full")}),$(".select select").on("change",function(){""!=$(this).val()?$(this).closest(".select").addClass("full"):$(this).closest(".select").removeClass("full")}),$("#openMore").on("click",function(e){e.preventDefault(),$(this).closest(".more").toggleClass("active"),$(this).find("span").toggleClass("hidden")})});