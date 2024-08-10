/*---------------------------
DribbleData Project
Created by Matvey Guralskiy
---------------------------*/

document.addEventListener('DOMContentLoaded', function () {
    const videoPlayer = document.getElementById('video-player');
    const videoLinks = document.querySelectorAll('.video-list a');

    videoLinks.forEach(link => {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            const videoUrl = this.getAttribute('data-video');
            const videoSource = document.getElementById('video-source');
            videoSource.src = videoUrl;
            videoPlayer.load();
            videoPlayer.play();
        });
    });
});
