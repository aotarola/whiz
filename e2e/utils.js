import electron from 'electron';
import chai from 'chai'
import chaiAsPromised from 'chai-as-promised';
import { Application } from 'spectron';

chai.should()
chai.use(chaiAsPromised)

var beforeEach = function () {
    this.timeout(10000);
    this.app = new Application({
        path: electron,
        args: ['app'],
        startTimeout: 10000,
        waitTimeout: 10000,
    });
    chaiAsPromised.transferPromiseness = this.app.transferPromiseness
    return this.app.start();
};

var afterEach = function () {
    this.timeout(10000);
    if (this.app && this.app.isRunning()) {
        return this.app.stop();
    }
};

export default {
    beforeEach: beforeEach,
    afterEach: afterEach,
};
