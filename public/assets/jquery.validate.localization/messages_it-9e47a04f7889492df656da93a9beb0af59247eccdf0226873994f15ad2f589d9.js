!function(i){"function"==typeof define&&define.amd?define(["jquery","../jquery.validate"],i):"object"==typeof module&&module.exports?module.exports=i(require("jquery")):i(jQuery)}(function(i){return i.extend(i.validator.messages,{required:"Campo obbligatorio",remote:"Controlla questo campo",email:"Inserisci un indirizzo email valido",url:"Inserisci un indirizzo web valido",date:"Inserisci una data valida",dateISO:"Inserisci una data valida (ISO)",number:"Inserisci un numero valido",digits:"Inserisci solo numeri",creditcard:"Inserisci un numero di carta di credito valido",equalTo:"Il valore non corrisponde",extension:"Inserisci un valore con un&apos;estensione valida",maxlength:i.validator.format("Non inserire pi&ugrave; di {0} caratteri"),minlength:i.validator.format("Inserisci almeno {0} caratteri"),rangelength:i.validator.format("Inserisci un valore compreso tra {0} e {1} caratteri"),range:i.validator.format("Inserisci un valore compreso tra {0} e {1}"),max:i.validator.format("Inserisci un valore minore o uguale a {0}"),min:i.validator.format("Inserisci un valore maggiore o uguale a {0}"),nifES:"Inserisci un NIF valido",nieES:"Inserisci un NIE valido",cifES:"Inserisci un CIF valido",currency:"Inserisci una valuta valida"}),i});