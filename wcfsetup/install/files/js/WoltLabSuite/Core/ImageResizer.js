/**
 * This module allows resizing and conversion of HTMLImageElements to Blob and File objects
 *
 * @author	Maximilian Mader
 * @copyright	2001-2018 WoltLab GmbH
 * @license	GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @module	WoltLabSuite/Core/ImageResizer
 */
define([], function() {
	/**
	 * @constructor
	 */
	function ImageResizer() { }
	
	ImageResizer.prototype = {
		maxWidth: 800,
		maxHeight: 600,
		quality: 0.8,
		fileType: 'image/jpeg',

		setMaxWidth: function (value) {
			if (value == null) value = ImageResizer.prototype.maxWidth;
			
			this.maxWidth = value;
			return this;
		},
		
		setMaxHeight: function (value) {
			if (value == null) value = ImageResizer.prototype.maxHeight;
			
			this.maxHeight = value;
			return this;
		},
		
		setQuality: function (value) {
			if (value == null) value = ImageResizer.prototype.quality;
			
			this.quality = value;
			return this;
		},
		
		setFileType: function (value) {
			if (value == null) value = ImageResizer.prototype.fileType;
			
			this.fileType = value;
			return this;
		},
		
		blobToFile: function (blob, name) {
			var ext = '';
			switch (blob.type) {
				case 'image/png':
					ext = '.png';
					break;
				
				case 'image/jpeg':
					ext = '.jpg';
					break;
				
				case 'image/gif':
					ext = '.gif';
					break;
				
				default:
					ext = blob.type.split('/')[1];
			}
			
			return new File([blob], name.match(/(.+)(\..+?)$/)[1] + "_autoscaled" + ext);
		},
		
		getFile: function (canvas, fileName, fileType, quality) {
			return this.getBlob(canvas, fileType, quality).then((function (blob) {
				return this.blobToFile(blob, fileName);
			}).bind(this));
		},
		
		getBlob: function (canvas, fileType, quality) {
			fileType = fileType || this.fileType;
			quality = quality || this.quality;
			
			return new Promise(function (resolve, reject) {
				// Create a new image blob
				if (typeof canvas.toBlob === 'function') {
					canvas.toBlob(resolve, fileType, quality);
				}
				else {
					// Fallback for browsers like Edge that do not implement toBlob()
					var binary = atob(canvas.toDataURL(fileType, quality).split(',')[1]);
					var length = binary.length;
					var data = new Uint8Array(length);
					
					for (var i = 0; i < length; i++) {
						data[i] = binary.charCodeAt(i);
					}
					
					resolve(new Blob([data], {type: fileType}));
				}
			});
		},
		
		getImageTag: function (canvas, fileType, quality) {
			fileType = fileType || this.fileType;
			quality = quality || this.quality;
			
			var dataURL = canvas.toDataURL(fileType, quality);
			var image = new Image();
			image.src = dataURL;
			
			return image;
		},
		
		resize: function (image, maxWidth, maxHeight) {
			maxWidth = maxWidth || this.maxWidth;
			maxHeight = maxHeight || this.maxHeight;
			
			var canvas = document.createElement('canvas');
			var ctx = canvas.getContext('2d');
			
			// Prevent upscalingq
			var newWidth = Math.min(maxWidth, image.width);
			var newHeight = Math.min(maxHeight, image.height);
			
			// Keep image ratio
			if (image.width >= image.height) {
				canvas.width = newWidth;
				canvas.height = newWidth * (image.height / image.width);
			}
			else {
				canvas.width = newHeight * (image.width / image.height);
				canvas.height = newHeight;
			}
			
			// We return a Promise, to aid supporting asynchronous resizing later on
			return new Promise(function (resolve) {
				// TODO: If possible, resize the image in a WebWorker, otherwise the UI thread may be blocked for larger images
				
				// Scale the image down
				// TODO: Evaluate if a custom downsampling algorithm like Hermite downsampling should be implemented
				ctx.drawImage(image, 0, 0, canvas.width, canvas.height);
				
				resolve(canvas);
			});
		}
	};
	
	return ImageResizer;
});
