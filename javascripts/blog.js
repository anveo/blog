$(function() {
    $('h1, h2, h3, h4, h5, h6').hover(
        function () {
            $(this).find('a.anchor').css('display', 'inline');
        }, 
        function () {
            $(this).find('a.anchor').css('display', 'none');
        }
    );
});
