$("#myButton").click(function(){
  $("#myInput").prop("value", "12345678");
});


$(document).on('click', '.upload-btn', function(){
	$('#foto').click();
});

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#preview-foto').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }
}

$("#foto").change(function(){
    readURL(this);
});

$(function() {
  $("form[name='create_form']").validate({
    rules: {
      username: "required",
      password: "required",
      dn: "required",
      team: "required",
      position: "required",
      softphone: "required",
      fullname: {
        required: true,
        minlength: 4
      },
      JOIN_DATE:"required",
      STATUS_USER:"required"
      
   
    },
    messages: {
      nama: "Nama tidak boleh kosong",
      team:"you may choose team",
      username: "Username tidak boleh kosong",
      fullname: "Fullname tidak boleh kosong",
      password: "Password tidak boleh kosong",
      dn:"Password tidak boleh kosong",
      position: "Silakan pilih posisi",
      softphone: "Silakan pilih posisi",
      JOIN_DATE:"Silakan pilih join date",
      STATUS_USER:"Silakan pilih status user"
    },
    errorPlacement: function(error, element) {
        var name = element.attr("name");
        $("#" + name + "_error").html(error);
        $("#" + name + "_error").children().addClass('col-form-label');
    },
    submitHandler: function(form) {
      form.submit();
    }
  });
});