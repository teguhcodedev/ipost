jQuery(document).ready(function ()
{
        jQuery('select[name="position"]').on('change',function(){
           var position = jQuery(this).val();
           console.log(position)
          
           if(position==="TELEMARKETER")
           {
              jQuery.ajax({
                 url : 'getspv',
                 type : "GET",
                 dataType : "json",
                 success:function(data)
                 {
                    console.log('spv',data);
                    jQuery('select[name="supervisor"]').empty();
                    jQuery('select[name="supervisor"]').prop('disabled', false);
                    $('select[name="supervisor"]').append('<option value="">Select Supervisor</option>');
                    jQuery.each(data, function(key,value){
                       $('select[name="supervisor"]').append('<option value="'+ value +'">'+ value +'</option>');
                    });
                 }
              });
              jQuery.ajax({
                 url : 'getmanager',
                 type : "GET",
                 dataType : "json",
                 success:function(data)
                 {
                    console.log('manager',data);
                    jQuery('select[name="manager"]').prop('disabled', false);
                    jQuery('select[name="manager"]').empty();
                    $('select[name="manager"]').append('<option value="">Select Manager</option>');
                    jQuery.each(data, function(key,value){
                       $('select[name="manager"]').append('<option value="'+ value +'">'+ value +'</option>');
                    });
                 }
              });
           }

           else if(position==="SUPERVISOR"  )
           {
            
              jQuery.ajax({
                 url : 'getmanager',
                 type : "GET",
                 dataType : "json",
                 success:function(data)
                 {
                    console.log('manager',data);
                    jQuery('select[name="manager"]').prop('disabled', false);
                    jQuery('select[name="manager"]').empty();
                    $('select[name="manager"]').append('<option value="">Select Manager</option>');
                    jQuery.each(data, function(key,value){
                       $('select[name="manager"]').append('<option value="'+ key +'">'+ value +'</option>');
                    });
                 }
              })
              jQuery('select[name="supervisor"]').prop('disabled', true);
              $('select[name="supervisor"]').empty();
           }

           else if( position==="QUALITY ASSURANCE" )
           {
            
              jQuery.ajax({
                 url : 'getmanager',
                 type : "GET",
                 dataType : "json",
                 success:function(data)
                 {
                    console.log('manager',data);
                    jQuery('select[name="manager"]').prop('disabled', false);
                    jQuery('select[name="manager"]').empty();
                    $('select[name="manager"]').append('<option value="">--- Select Manager ---</option>');
                    jQuery.each(data, function(key,value){
                       $('select[name="manager"]').append('<option value="'+ key +'">'+ value +'</option>');
                    });
                 }
              })
           }
           else
           {
              jQuery('select[name="supervisor"]').prop('disabled', true);
              jQuery('select[name="manager"]').prop('disabled', true);
              $('select[name="supervisor"]').append('<option value="">--- Select Supervisor ---</option>');
              $('select[name="manager"]').append('<option value="">--- Select Manager ---</option>');
               $('select[name="supervisor"]').empty();
               $('select[name="manager"]').empty();
           }
        });

        jQuery('select[name="STATUS_USER"]').on('change',function(){
           var status_user = jQuery(this).val();
           if(status_user === "RESIGN" || status_user === "TERMINATED" ){
           jQuery('input[name="date_resign"]').prop('disabled', false);
           }else{
              jQuery('input[name="date_resign"]').prop('disabled', true);
           }
        })
});