var soundcloud = {}, helpers = {};

var soundCloudRetry = function() {
    if (window.soundcloud != undefined) {
        console.log('Setting soundcloud to window.soundcloud');
        soundcloud = window.soundcloud;
    } else {
        console.log('Will try again.');
        window.setTimeout( soundCloudRetry, 250);
    }
};

var helpersRetry = function() {
    if (window.helpers != undefined) {
        console.log('Setting helpers to window.helpers');
        helpers = window.helpers;
    } else {
        console.log('Will try again.');
        window.setTimeout( helpersRetry, 250);
    }
};
