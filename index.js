var request = require('request');
var colors = require('colors');

var pageInsightsUrl = 'https://www.googleapis.com/pagespeedonline/v2/runPagespeed?url=http%3A%2F%2F'
var pages = [
  'autovrakoviste-dipa.cz',
  'motoservisjelinek.cz',
  'fbctremosnice.4fan.cz'
];

/**
 * @param {Error?} err
 * @param {object} response
 * @param {string} body
 */
function requestPageInsight (page) {
  request(pageInsightsUrl + page, function processResponse (err, response, body) {
    if (!err && response.statusCode == 200) {
      console.log(page.green);
      printReport(JSON.parse(body))
    } else {
      console.log(page.red);
      if (err) {
        console.error(err)
      } else if (response.body) {
        var error = JSON.parse(response.body).error;
        console.log(error.message);
      } else {
        console.log(response.statusCode);
      };
    }
  });
}
/**
 * @param {object} report
 */
function printReport (report) {
  var ruleId,
    rule,
    impact;

  console.log('Speed'.grey, (report.ruleGroups.SPEED.score + '%').green );

  for (ruleId in report.formattedResults.ruleResults) {
    rule = report.formattedResults.ruleResults[ruleId];
    impact = rule.ruleImpact.toFixed(2);

    console.log('  *', impact, getFormattedSummary(rule.summary));
  }
}

/**
 * @param {object} summaryObject
 * @return {string} formatted summary
 */
function getFormattedSummary (summary) {
  var formatted = summary.format;

  summary.args && summary.args.forEach(function replaceVariable (arg) {
    switch (arg.type) {
      case 'HYPERLINK':
        formatted = formatted.replace('{{BEGIN_LINK}}', '').replace('{{END_LINK}}', '');
        break;
      default:
        formatted = formatted.replace('{{'+ arg.key + '}}', arg.value);
    }
  });

  return formatted;
}

pages.forEach(requestPageInsight);
