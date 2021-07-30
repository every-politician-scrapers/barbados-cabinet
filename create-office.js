// wd create-entity create-office.js "Minister for X"
module.exports = (label) => {
  return {
    type: 'item',
    labels: {
      en: label,
    },
    descriptions: {
      en: 'government position in Barbados',
    },
    claims: {
      P31:   { value: 'Q294414' }, // instance of: public office
      P279:  { value: 'Q83307'  }, // subclas of: minister
      P1001: { value: 'Q244'    }, // jurisdiction: Barbados
      P361: {
        value: 'Q5015493',         // part of: Cabinet of Barbados
        references: {
          P854: 'https://www.gov.bb/Government/cabinet'
        },
      }
    }
  }
}
