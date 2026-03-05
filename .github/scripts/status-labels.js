// Shared constants for GitHub Actions workflows
// Place this file in .github/scripts/status-labels.js

const STATUS_LABELS = ['Backlog', 'Accepted', 'To do', 'In progress', 'Done', 'Pre-release', 'Release'];
const LABEL_COLORS = {
  'Backlog':      '0e8a16',
  'Accepted':     '0075ca',
  'To do':        '0075ca',
  'In progress':  'fbca04',
  'Done':         'e4681e',
  'Pre-release':  'e99695',
  'Release':      '5319e7',
};

module.exports = { STATUS_LABELS, LABEL_COLORS };