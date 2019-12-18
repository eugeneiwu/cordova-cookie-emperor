var exec = require('cordova/exec');

/**
 * Returns tensorflow value
 * 
 *  Use can see this example below:
 * 
 *      var imageBase64 = "IMG_BASE_64_HERE";
 *      var modelName = "example_model";
 * 
        cordova.plugins.TensorFlowFidelidadePlugin.loadModel(modelName, imageBase64,
            function success(data) {
                alert("Result: "+data.value);
            },
            function error(data) {
                alert("Error: "+data);
            }
        );
 * 
 * @param modelName the model name of the file already exists
 * @param imagePath the image path with image content
 * @param successCallback the success
 * @param errorCallback the error
 */
exports.loadModel = function(modelName, imagePath, successCallback, errorCallback) {
    exec(successCallback, errorCallback,  'TensorFlowFidelidadePlugin', 'loadModel', [modelName, imagePath]);
};
