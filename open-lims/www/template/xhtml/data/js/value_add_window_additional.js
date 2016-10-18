//load the template corresponding to the selected value id (second call)
$('#AjaxLoadedContent').jScrollPane();
load_additional_content();

var scrollAPI = $('#AjaxLoadedContent').data('jsp');
$('#DataBrowserAddValue').change(function(){
	load_additional_content();
});

function load_additional_content()
{
	var type_id = $('#DataBrowserAddValue option:selected').val();
	$("#DataBrowserAddValue").parent().addClass("Form");
	$.ajax({
		type : "POST",
		url : "ajax.php?session_id=[[SESSION_ID]]&nav=data&run=value_add",
		data : "type_id="+type_id,
		success : function(data) 
		{
			value_handler = new ValueHandler("DataValueAddValues", "[[DECIMAL_SEPARATOR]]", "[[THOUSAND_SEPARATOR]]");

			$('#AjaxLoadedContent').find('.jspVerticalBar').show();
			$('#AjaxLoadedContent').children('.jspContainer').children('.jspPane').html(data);
			scrollAPI.reinitialise();
			var content_height = scrollAPI.getContentHeight();
			if(content_height > 320)
			{	
				$('#AjaxLoadedContent').children('.jspContainer').css('height',320);
			}
			else
			{
				$('#AjaxLoadedContent').children('.jspContainer').css('height',content_height);
			} 
			scrollAPI.reinitialise();
			if($('#AjaxLoadedContent').find('.jspDrag').height() == content_height)
			{
				$('#AjaxLoadedContent').find('.jspVerticalBar').hide();
			} 
			base_form_init();
		}
	});
}