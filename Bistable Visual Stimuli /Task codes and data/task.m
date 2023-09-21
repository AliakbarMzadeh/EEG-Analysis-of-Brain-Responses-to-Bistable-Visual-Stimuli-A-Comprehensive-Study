clear;
close all;
clc;
PsychDebugWindowConfiguration;
Screen('Preference','SkipSyncTests',1);


%moviename = [];
moviename = '*.mov';
hdr = 0;

PsychDefaultSetup(2);

% Setup key mapping:
space=KbName('SPACE');
esc=KbName('ESCAPE');
right=KbName('RightArrow');
left=KbName('LeftArrow');
up=KbName('UpArrow');
down=KbName('DownArrow');
shift=KbName('RightShift');
colorPicker=KbName('c');

try
    % Open onscreen window with gray background:
    screen = max(Screen('Screens'));
    PsychImaging('PrepareConfiguration');

    % No special movieOptions by default:
    movieOptions = [];

    % Enable HDR display in HDR-10 mode if requested by user:
    if hdr
        PsychImaging('AddTask', 'General', 'EnableHDR', 'Nits', 'HDR10');

        if hdr == 3 || hdr == 4
            if IsLinux && ~IsWayland
                PsychImaging('AddTask', 'General', 'UseStaticHDRHack');
            else
                warning('hdr settings 3 and 4 unsupported on non-Linux. Ignored.');
            end
        end

        % Special hack for running HDR movie playback on GStreamer versions older
        % than 1.18.0. Those can not detect the EOTF transfer functions of HDR-10
        % video footage, neither type 14 PQ, nor type 15 HLG. If user passes in a
        % hdr == 2 flag, override automatic EOTF detection to always assume EOTF
        % type 14 instead. Type 14 is the SMPTE ST-2084 PQ "Perceptual Quantizer",
        % the most common EOTF used in typical HDR-10 movie content.
        % (Obviously, SDR content will look really weird, if played back with this
        % override in use, so viewer discretion is advised ;)):
        if hdr == 2 || hdr == 4
            movieOptions = 'OverrideEOTF=14';
        end
    end

    win = PsychImaging('OpenWindow', screen, [0.5, 0.5, 0.5]);
    [w, h] = Screen('WindowSize', win);
    Screen('Blendfunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    HideCursor(win);

    shader = [];
    if (nargin > 2) && ~isempty(backgroundMaskOut)
        if nargin < 4
            tolerance = [];
        end
        shader = CreateSinglePassImageProcessingShader(win, 'BackgroundMaskOut', backgroundMaskOut, tolerance);
    end

    % Use default pixelFormat if none specified:
    if nargin < 5
        pixelFormat = [];
    end

    % On ARM set the default pixelFormat to 6 for shader based decode.
    % On a RaspberryPi-4 this makes a world of difference when playing
    % HD movies, between slow-motion 2 fps and proper 24 fps playback.
    if isempty(pixelFormat) && IsARM
        pixelFormat = 6;
    end

    % Use default maxThreads if none specified:
    if nargin < 6
        maxThreads = [];
    end

    % Initial display and sync to timestamp:
    Screen('Flip',win);
    iteration = 0;
    abortit = 0;

    % Use blocking wait for new frames by default:
    blocking = 1;

    % Default preload setting:
    preloadsecs = [];

    if isempty(strfind(moviename, 'http')) %#ok<STREMP>
        % Return full list of movie files from directory+pattern:
        folder = fileparts(moviename);
        if isempty(folder)
            folder = pwd;
        end
        moviefiles = dir(moviename);

        if isempty(moviefiles)
       %     moviefiles(1).name = [ PsychtoolboxRoot 'PsychDemos/MovieDemos/DualDiscs.mov' ];
            moviefiles(1).name = [ PsychtoolboxRoot 'PsychDemos/MovieDemos/bp.mov' ];
        else
            for i=1:size(moviefiles,1)
                moviefiles(i).name = [ folder filesep moviefiles(i).name ];
            end
        end

        moviecount = size(moviefiles,1);
    else
        moviefiles(1).name = moviename;
        moviecount = 1;
    end

    if strcmpi(theanswer, 'c')
        % Cool stuff, streaming from the web ;-)
        coolstuff = 1;
        moviefiles = [];

        % Make sure a cache directory for buffering exists.
        try
            PsychHomeDir('.cache');
        catch
        end

        % Linus Torvalds DebConf 2014 Q & A:
        moviefiles(end+1).name = 'http://meetings-archive.debian.net/pub/debian-meetings/2014/debconf14/webm/QA_with_Linus_Torvalds.webm';
        moviefiles(end).url = 'http://meetings-archive.debian.net/pub/debian-meetings/2014/debconf14/webm/QA_with_Linus_Torvalds.webm';
        moviefiles(end).credits = 'Q & A at DebConf 2014 with Linus Torvalds';

        % MC Hammers Can't touch this - performed by a special ensemble:
        moviefiles(end+1).name = 'http://archive.org/download/juniorx3_dancevideo2/juniorx3_dancevideo2.ogv';
        moviefiles(end).url = 'http://archive.org/details/juniorx3_dancevideo2';
        moviefiles(end).credits = 'MC Hammers Can''t touch this - performed by a special ensemble';

        % The Godfather of Soul giving quick dance lessons:
        moviefiles(end+1).name = 'http://archive.org/download/9lines-JamesBrownDancingLessons151/9lines-JamesBrownDancingLessons151.ogv';
        moviefiles(end).url = 'http://archive.org/details/9lines-JamesBrownDancingLessons151';
        moviefiles(end).credits = 'The Godfather of Soul giving quick dance lessons';

        % Randy Pausch's "Last lecture":
        moviefiles(end+1).name = 'http://archive.org/download/LastLecturebyRandyPausch/Last_Lecture_by_Randy_Pausch_Sept_2007_MWV.ogv';
        moviefiles(end).url = 'http://archive.org/details/LastLecturebyRandyPausch';
        moviefiles(end).credits = 'Randy Pausch''s Last Lecture "Achieving Your Childhood Dreams"';

        % Richard Stallman talks about the dangers of software patents:
        moviefiles(end+1).name = 'http://archive.org/download/ifso-stallman/ifso-stallman-mpeg1_512kb.mp4';
        moviefiles(end).url = 'http://archive.org/details/ifso-stallman';
        moviefiles(end).credits = 'Richard Stallman talks about the dangers of software patents';

        % Linus Torvalds talks at Aalto University Finnland:
        moviefiles(end+1).name = 'http://archive.org/download/AaltoTalkWithLinusTorvalds/AaltoTalkWithLinusTorvalds.ogv';
        moviefiles(end).url = 'http://archive.org/details/AaltoTalkWithLinusTorvalds';
        moviefiles(end).credits = 'Linux creator and Millenium prize 2012 winner Linus Torvalds talks at Aalto University Finnland';

        % Elon Musk talks about electrical cars, space-flight and solar power:
        moviefiles(end+1).name = 'http://video.ted.com/talk/podcast/2013/None/ElonMusk_2013.mp4';
        moviefiles(end).url = 'http://www.ted.com/talks/elon_musk_the_mind_behind_tesla_spacex_solarcity.html';
        moviefiles(end).credits = 'At TED Elon Musk talks with Chris Anderson about electrical cars, space-flight and solar power';

        % Count all movies in our playlist:
        moviecount = size(moviefiles,2);

        if moviecount == 0
            fprintf('Sorry, i do not have any cool movies for your system configuration. Will use boring default movie file.\n');
            moviefiles(1).name = [ PsychtoolboxRoot 'PsychDemos/MovieDemos/DualDiscs.mov' ];
        end

        % Use polling to wait for new frames when playing movies from the
        % internet. This to make sure we don't time out too early or block
        % for too long if the network connection is slow / high-latency / bad.
        blocking = 0;
    else
        coolstuff = 0;
    end

    % Playbackrate defaults to 1:
    rate=1;

    % No mouse color prober/picker by default - Performance impact!
    colorprobe = 0;

    % Choose 16 pixel text size:
    Screen('TextSize', win, 16);

    % Endless loop, runs until ESC key pressed:
    while (abortit<2)
        if coolstuff
            url = moviefiles(mod(iteration, moviecount)+1).url;
            credits = moviefiles(mod(iteration, moviecount)+1).credits;
        end
        moviename = moviefiles(mod(iteration, moviecount)+1).name;
        iteration = iteration + 1;
        fprintf('ITER=%i::', iteration);

        % Show title while movie is loading/prerolling:
        DrawFormattedText(win, ['Loading ...\n' moviename], 'center', 'center', 0, 40);
        Screen('Flip', win);

        % Open movie file and retrieve basic info about movie:
        [movie, movieduration, fps, imgw, imgh, ~, ~, hdrStaticMetaData] = Screen('OpenMovie', win, moviename, [], preloadsecs, [], pixelFormat, maxThreads, movieOptions);
        fprintf('Movie: %s  : %f seconds duration, %f fps, w x h = %i x %i...\n', moviename, movieduration, fps, imgw, imgh);
        if imgw > w || imgh > h
            % Video frames too big to fit into window, so define size to be window size:
            dstRect = CenterRect((w / imgw) * [0, 0, imgw, imgh], Screen('Rect', win));
        else
            dstRect = [];
        end

        if hdrStaticMetaData.Valid
            fprintf('Static HDR metadata is:\n');
            disp(hdrStaticMetaData);
            ColorGamut = hdrStaticMetaData.ColorGamut %#ok<NOPRT,NASGU>
            fprintf('\n');
            if hdr
                % If HDR mode is enabled and the movie has HDR-10 static
                % metadata attached, also provide it to the HDR display, in
                % the hope it will somehow enhance reproduction of the
                % visual movie content:
                PsychHDR('HDRMetadata', win, hdrStaticMetaData);
            end
        end

        i=0;

        % Start playback of movie. This will start
        % the realtime playback clock and playback of audio tracks, if any.
        % Play 'movie', at a playbackrate = 1, with endless loop=1 and
        % 1.0 == 100% audio volume.
        Screen('PlayMovie', movie, rate, 1, 1.0);

        t1 = GetSecs;

        % Infinite playback loop: Fetch video frames and display them...
        while 1
            % Check for abortion:
            abortit=0;
            [keyIsDown, ~, keyCode] = KbCheck(-1);
            if (keyIsDown==1 && keyCode(esc))
                % Set the abort-demo flag.
                abortit=2;
                break;
            end

            % Check for skip to next movie:
            if (keyIsDown==1 && keyCode(space))
                % Exit while-loop: This will load the next movie...
                break;
            end

            % Only perform video image fetch/drawing if playback is active
            % and the movie actually has a video track (imgw and imgh > 0):
            if ((abs(rate)>0) && (imgw>0) && (imgh>0))
                % Return next frame in movie, in sync with current playback
                % time and sound.
                % tex is either the positive texture handle or zero if no
                % new frame is ready yet in non-blocking mode (blocking == 0).
                % It is -1 if something went wrong and playback needs to be stopped:
                tex = Screen('GetMovieImage', win, movie, blocking);

                % Valid texture returned?
                if tex < 0
                    % No, and there won't be any in the future, due to some
                    % error. Abort playback loop:
                    break;
                end

                if tex == 0
                    % No new frame in polling wait (blocking == 0). Just sleep
                    % a bit and then retry.
                    WaitSecs('YieldSecs', 0.005);
                    continue;
                end

                % Draw the new texture immediately to screen:
                Screen('DrawTexture', win, tex, [], dstRect, [], [], [], [], shader);

                DrawFormattedText(win, ['Movie: ' moviename ], 'center', 20, 0);
                if coolstuff
                    DrawFormattedText(win, ['Original URL: ' url '\n\n' credits], 'center', 60, 0);
                end

                if colorprobe
                    % Take a screenshot of the pixel below the mouse:
                    [xm, ym] = GetMouse(win);
                    mouseposrgb = Screen('GetImage', win, OffsetRect([0 0 1 1], xm, ym), 'drawBuffer', 1);
                    if hdr
                        DrawFormattedText(win, sprintf('RGB at cursor position (%f, %f): (%f, %f, %f) nits.\n', xm, ym, mouseposrgb), 0, 50, [100 100 0]);
                    else
                        DrawFormattedText(win, sprintf('RGB at cursor position (%f, %f): (%f, %f, %f).\n', xm, ym, mouseposrgb), 0, 50, [1 1 0]);
                    end

                    % Draw tiny yellow cursor dot:
                    [~, mi] = max(mouseposrgb);
                    switch (mi)
                        case 1
                            cursorcolor = [0, 200, 200];
                        case 2
                            cursorcolor = [200, 0, 200];
                        case 3
                            cursorcolor = [200, 200, 0];
                    end
                    Screen('DrawDots', win, [xm, ym], 3, cursorcolor);
                end

                % Update display:
                Screen('Flip', win);
                
                % Release texture:
                Screen('Close', tex);
                
                % Framecounter:
                i=i+1;
            end

            % Further keyboard checks...
            if (keyIsDown==1 && keyCode(right))
                % Advance movietime by one second:
                Screen('SetMovieTimeIndex', movie, Screen('GetMovieTimeIndex', movie) + 1);
            end

            if (keyIsDown==1 && keyCode(left))
                % Rewind movietime by one second:
                Screen('SetMovieTimeIndex', movie, Screen('GetMovieTimeIndex', movie) - 1);
            end

            if (keyIsDown==1 && keyCode(up))
                % Increase playback rate by 1 unit.
                if (keyCode(shift))
                    rate=rate+0.1;
                else
                    KbReleaseWait;
                    rate=round(rate+1);
                end
                Screen('PlayMovie', movie, rate, 1, 1.0);
            end

            if (keyIsDown==1 && keyCode(down))
                % Decrease playback rate by 1 unit.
                if (keyCode(shift))
                    rate=rate-0.1;
                else
                    KbReleaseWait;
                    rate=round(rate-1);
                end
                Screen('PlayMovie', movie, rate, 1, 1.0);
            end

            if (keyIsDown==1 && keyCode(colorPicker))
                % Toggle color prober / picker:
                colorprobe = 1 - colorprobe;
                % Debounce:
                KbReleaseWait(-1);
            end
        end

        telapsed = GetSecs - t1;
        fprintf('Elapsed time %f seconds, for %i frames. Average framerate %f fps.\n', telapsed, i, i / telapsed);

        Screen('Flip', win);
        KbReleaseWait;

        % Done. Stop playback:
        Screen('PlayMovie', movie, 0);

        % Close movie object:
        Screen('CloseMovie', movie);
    end

    % Show cursor again:
    ShowCursor(win);

    % Close screens.
    sca;

    % Done.
    return;
catch %#ok<*CTCH>
    % Error handling: Close all windows and movies, release all ressources.
    sca;
    rethrow(lasterror); %#ok<LERR>