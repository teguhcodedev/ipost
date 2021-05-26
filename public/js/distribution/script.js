$(".number-mutlak").inputFilter(function(value) {
    return  /^\d*[.]?\d*$/.test(value);
  });
