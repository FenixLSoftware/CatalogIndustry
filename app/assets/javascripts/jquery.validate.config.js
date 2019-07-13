/**
 * Created by sergio on 11/4/18.
 */
$(function () {
    $.validator.addMethod("require_one_lang", function (value, element, options) {
        // Get message error from element dataset if exists (data-group-message)
        if ($(element).data('groupMessage') === undefined) {
            $.validator.messages.require_one_lang = 'Please fill at least in one language';
        } else {
            $.validator.messages.require_one_lang = $(element).data('groupMessage');
        }

        var $fields = $(options[0], element.form),
            $fieldsFirst = $fields.eq(0),
            validator = $fieldsFirst.data("valid_req_grp") ? $fieldsFirst.data("valid_req_grp") : $.extend({}, this),
            isValid = $fields.filter(function () {
                    return validator.elementValue(this);
                }).length >= 1;

        // Store the cloned validator for future validation
        $fieldsFirst.data("valid_req_grp", validator);

        // If element isn't being validated, run each require_from_group field's validation rules
        if (!$(element).data("being_validated")) {
            $fields.data("being_validated", true);
            $fields.each(function () {
                validator.element(this);
            });
            $fields.data("being_validated", false);
        }
        return isValid;
    }, $.validator.messages.require_one_lang);

    // Add custom rules for css classes
    $.validator.addClassRules({
        lang_name: {
            require_one_lang: [".name-group"]
        },
        lang_desc: {
            require_one_lang: [".desc-group"]
        },
        lang_keywords: {
            require_one_lang: [".keywords-group"]
        },
        lang_pdf: {
            require_one_lang: [".pdf-group"]
        },
        lang_url: {
            require_one_lang: [".url-group"]
        }
    });

    $('form.form_validate').each(function () {
        $(this).validate({
            ignore: [],
            errorElement: 'div',
            errorPlacement: function (error, element) {
                if (element.attr("type") === "checkbox") {
                    error.insertAfter($(element).siblings().last());
                } else {
                    error.insertAfter(element);
                }
            }
        });
    });

});
