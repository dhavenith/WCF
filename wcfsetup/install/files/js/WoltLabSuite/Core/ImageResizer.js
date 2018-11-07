/**
 * This module allows resizing and conversion to File objects of HTMLImageElements
 *
 * @author	Maximilian Mader
 * @copyright	2001-2018 WoltLab GmbH
 * @license	GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @module	WoltLabSuite/Core/ImageResizer
 */
define([], function() {
	function ImageResizer() {
		this.canvas = document.createElement('canvas');
		this.ctx = this.canvas.getContext('2d');
	}
	
	ImageResizer.prototype = {
		maxWidth: 800,
		maxHeight: 600,
		maxFileSize: null,
		quality: 0.7,
		fileType: 'image/jpeg',
		
		setMaxWidth: function (value) {
			this.maxWidth = value;
			return this;
		},
		
		setMaxHeight: function (value) {
			this.maxHeight = value;
			return this;
		},
		
		setQuality: function (value) {
			this.quality = value;
			return this;
		},
		
		setFileType: function (value) {
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
			
			return new File([blob], name.split(/(.+)(\..+?)$/)[1] + "_autoscaled" + ext);
		},
		
		resize: function (image, fileName) {
			var self = this;
			var fileType = this.fileType ? this.fileType : file.type;
			
			// TODO: If possible, resize the image in a WebWorker, otherwise the UI thread may be blocked for larger images
			return new Promise(function (resolve, reject) {
				// Keep image ratio
				if (image.width >= image.height) {
					self.canvas.width = self.maxWidth;
					self.canvas.height = self.maxWidth * (image.height / image.width);
				}
				else {
					self.canvas.width = self.maxHeight * (image.width / image.height);
					self.canvas.height = self.maxHeight;
				}
				
				// Scale the image down
				// TODO: Evaluate if a custom downsampling algorithm like Hermite downsampling should be implemented
				self.ctx.drawImage(image, 0, 0, self.canvas.width, self.canvas.height);
				
				// Create a new image blob
				try {
					if (HTMLCanvasElement.prototype.toBlob) {
						self.canvas.toBlob(function (blob) {
							resolve(self.blobToFile(blob, fileName));
						}, fileType, self.quality);
					}
					else {
						// Fallback for browsers like Edge that do not implement toBlob()
						var binary = atob(self.canvas.toDataURL(file.type, self.quality).split(',')[1]);
						var length = binary.length;
						var data = new Uint8Array(length);
						
						for (var i = 0; i < length; i++) {
							data[i] = binary.charCodeAt(i);
						}
						
						resolve(self.blobToFile(new Blob([data], {type: fileType}), fileName));
					}
				}
				catch (error) {
					reject(error);
				}
			});
		}
	};
	
	return ImageResizer;
});
