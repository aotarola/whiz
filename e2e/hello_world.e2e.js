import testUtils from './utils';

describe('application launch', function () {

    beforeEach(testUtils.beforeEach);
    afterEach(testUtils.afterEach);

    it('shows input text box', function () {
        return this.app.client.isExisting('#search-by-code')
          .should.eventually.be.true
    });


    it('finds a product', function () {
        return this.app.client
          .hasFocus('#search-by-code')
          .setValue('#search-by-code', '1')
          .click('#btn-search', '1')
          .waitForExist('#product-info')
          .hasFocus('#quantity-entry')
          .getText('#product-info')
          .should.eventually.be.equal('cerveza cristal | 43 |')
    });

    it('add a product to line items', function () {
        return this.app.client
          .hasFocus('#search-by-code')
          .setValue('#search-by-code', '1')
          .click('#btn-search', '1')
          .waitForExist('#product-info')
          .hasFocus('#quantity-entry')
          .getText('#product-info')
          .keys('Enter')
          .waitForExist('#lineitems')
          .getText('#lineitems > li')
          .should.eventually.be.equal('cerveza cristal 1')
    });

});
