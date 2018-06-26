$(function () {
	// ALERT: Yes, this is terrible security; it belongs in a .env file and is here for expedience
	const apiKey = '1aff0c69c2594ec6f68d3838ef7098f5';
	const applicationID = 'PUMEIQEW12';
	const indexName = 'algolia_demo';
	const client = algoliasearch(applicationID, apiKey);
	let helper = algoliasearchHelper(client, indexName)

	function renderHits(content) {
		$('#container').html(function () {
			return $.map(content.hits, function (hit) {
				return '<li>' + hit._highlightResult.name.value + '</li>';
			});
		});
	}

	$('#search-box').on('keyup', function () {
		helper.setQuery($(this).val()).search();
	});

	helper.on('result', function (content) {
		renderHits(content);
	});
});