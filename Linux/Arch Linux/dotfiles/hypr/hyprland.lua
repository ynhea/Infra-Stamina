```lua
-- =========================================================
--
-- 구성
--   Hyprland       → 창 관리 / Blur / Animation
--   Waybar         → macOS 스타일 상단 메뉴바
--   nwg-dock       → macOS 스타일 Dock
--   Wofi           → Spotlight 스타일 런처
--   Kitty          → 터미널
--   Fcitx5         → 한글 입력
--   Hyprpaper      → 배경화면
--
-- =========================================================


-- =========================================================
-- 1. 모니터 설정
-- 현재 연결된 모니터의 권장 해상도와 배율을 자동으로 사용
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


-- =========================================================
-- 2. 사용할 프로그램
-- 기본 터미널
local terminal = "kitty"

-- 파일 관리자
local fileManager = "dolphin"

-- 앱 런처
local menu = "wofi --show drun"


-- =========================================================
-- 3. 자동 실행 (처음 딱 1번만!)
hl.on("hyprland.start", function()

    -- 한글 입력기
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("sh -c 'sleep 1; fcitx5-remote -s hangul'")

    -- 네트워크 아이콘
    hl.exec_cmd("nm-applet")

    -- 상단 메뉴바
    hl.exec_cmd("waybar")
        
    -- Hyprpaper
    -- 실제 배경화면은 hyprpaper.conf에서 관리
    hl.exec_cmd("hyprpaper")

    -- nwg-dock-hyprland 하단 Dock
    hl.exec_cmd(
        "nwg-dock-hyprland -a center -i 48 -p bottom -l overlay -mb 20"
    )

    -- Hyprswitch 창 전환
    hl.exec_cmd(
        "sh -c 'command -v hyprswitch >/dev/null && hyprswitch init --show-title --size-factor 5.5 --workspaces-per-row 5 &'"
    )

end)


-- =========================================================
-- 4. 환경 변수

-- 커서 크기
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- 커서 테마
hl.env("XCURSOR_THEME", "macOS")

-- 그래픽 / 비디오 관련 환경 변수
hl.env("LIBVA_DRIVER_NAME", "iHD")
hl.env("VDPAU_DRIVER", "va_gl")
hl.env("GBM_BACKEND", "drm")

-- Wayland 세션 사용
hl.env("XDG_SESSION_TYPE", "wayland")

-- Fcitx5 한글 입력 관련 환경 변수
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("SDL_IM_MODULE", "fcitx")

-- Kitty에서 Fcitx5 입력을 정상적으로 사용하기 위한 설정
hl.env("GLFW_IM_MODULE", "ibus")


-- =========================================================
-- 5. 화면 / 창 디자인
-- =========================================================

hl.config({

    general = {
        -- 창과 창 사이의 간격
        gaps_in = 6,

        -- 화면 가장자리와 창 사이의 간격
        gaps_out = 16,

        -- 창 테두리
        border_size = 1,

        -- -------------------------------------------------
        -- 활성 / 비활성 창 테두리
        -- -------------------------------------------------
        col = {
            active_border = "rgba(ffffff33)",
            inactive_border = "rgba(ffffff18)",
        },

        -- 테두리를 잡아서 창 크기를 조절하는 기능
        resize_on_border = false,

        -- 화면 찢어짐 방지
        allow_tearing = false,

        -- 기본 레이아웃
        layout = "dwindle",
    },


    -- =====================================================
    -- 창 디자인
    -- =====================================================

    decoration = {
        rounding = 14,
        rounding_power = 2,
        active_opacity = 0.98,
        inactive_opacity = 0.94,
        shadow = {
            enabled = true,
            range = 8,
            render_power = 3,
            color = 0x55000000,
        },
        blur = {
            enabled = true,
            size = 5,
            passes = 2,
            vibrancy = 0.12,
        },
    },
    animations = {
        enabled = true,
    },
})


-- =========================================================
-- 6. Animation Curve (창과 관련된 그래픽 선언 -> 7번에서 활용)
-- =========================================================
hl.curve(
    "easeOutQuint",
    {
        type = "bezier",
        points = {
            {0.23, 1},
            {0.32, 1}
        }
    }
)

hl.curve(
    "easeInOutCubic",
    {
        type = "bezier",
        points = {
            {0.65, 0.05},
            {0.36, 1}
        }
    }
)

hl.curve(
    "linear",
    {
        type = "bezier",
        points = {
            {0, 0},
            {1, 1}
        }
    }
)

hl.curve(
    "almostLinear",
    {
        type = "bezier",
        points = {
            {0.5, 0.5},
            {0.75, 1}
        }
    }
)

hl.curve(
    "quick",
    {
        type = "bezier",
        points = {
            {0.15, 0},
            {0.1, 1}
        }
    }
)

hl.curve(
    "easy",
    {
        type = "spring",
        mass = 1,
        stiffness = 238.1191,
        dampening = 24.21279333
    }
)


-- =========================================================
-- 7. 창 애니메이션
-- =========================================================

-- 전체 애니메이션
hl.animation({
    leaf = "global",
    enabled = true,
    speed = 10,
    bezier = "default"
})


-- 창 테두리
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 5.39,
    bezier = "easeOutQuint"
})


-- 창 열기 / 닫기
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 4.79,
    spring = "easy"
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 4.1,
    spring = "easy",
    style = "popin 87%"
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.49,
    bezier = "linear",
    style = "popin 87%"
})


-- Fade
hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 1.73,
    bezier = "almostLinear"
})

hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 1.46,
    bezier = "almostLinear"
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 3.03,
    bezier = "quick"
})


-- Layer 애니메이션
hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 3.81,
    bezier = "easeOutQuint"
})

hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint",
    style = "fade"
})

hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 1.5,
    bezier = "linear",
    style = "fade"
})


-- Layer Fade
hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 1.79,
    bezier = "almostLinear"
})

hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 1.39,
    bezier = "almostLinear"
})


-- Workspace 애니메이션
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade"
})

hl.animation({
    leaf = "workspacesIn",
    enabled = true,
    speed = 1.21,
    bezier = "almostLinear",
    style = "fade"
})

hl.animation({
    leaf = "workspacesOut",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade"
})


-- Zoom
hl.animation({
    leaf = "zoomFactor",
    enabled = true,
    speed = 7,
    bezier = "quick"
})


-- =========================================================
-- 8. Dwindle Layout (분할)
-- =========================================================

hl.config({
    dwindle = {
        preserve_split = true,
    },
})


-- =========================================================
-- 9. Master Layout
-- =========================================================

hl.config({
    master = {
        new_status = "master",
    },
})


-- =========================================================
-- 10. Scrolling Layout
-- =========================================================

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})


-- =========================================================
-- 11. 배경화면
-- =========================================================

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
    },
})


-- =========================================================
-- 12. 입력 장치
-- =========================================================

hl.config({
    input = {
        kb_layout = "us",

        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        -- 마우스가 위치한 창에 자동으로 포커스
        follow_mouse = 1,

        -- 마우스 감도
        sensitivity = 0,

        -- 터치패드
        touchpad = {
            natural_scroll = true,
        },
    },
})


-- =========================================================
-- 13. 터치패드 제스처
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- =========================================================
-- 14. 마우스 장치별 설정
hl.device({
    name = "elan0e04:00-04f3:32e6-mouse",
    sensitivity = -0.5,
})


-- =========================================================
-- 15. 키 바인딩 (단축키)
local mainMod = "SUPER"

-- SUPER + SPACE = Wofi 실행
hl.bind(
    "SUPER + SPACE",
    hl.dsp.exec_cmd(menu)
)

-- Mission Control / 창 전환 = hyprswitch 실행
hl.bind(
    "F3",
    hl.dsp.exec_cmd(
        "sh -c 'command -v hyprswitch >/dev/null && hyprswitch gui --mod-key super --key f3 --max-switch-offset 9 || notify-send \"Mission Control\" \"Install hyprswitch to enable the window overview.\"'"
    )
)

-- SUPER + ENTER = Kitty 실행
hl.bind(
    "SUPER + Return",
    hl.dsp.exec_cmd(terminal)
)

-- SUPER + C = 창 닫기
hl.bind(
    mainMod .. " + C",
    hl.dsp.window.close()
)

-- SUPER + M = hyprland 종료
hl.bind(
    mainMod .. " + M",
    hl.dsp.exec_cmd(
        "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
    )
)

-- SUPER + E = 파일관리자
hl.bind(
    mainMod .. " + E",
    hl.dsp.exec_cmd(fileManager)
)

-- SUPER + V = 창을 Floating 전환
hl.bind(
    mainMod .. " + V",
    hl.dsp.window.float({
        action = "toggle"
    })
)

-- SUPER + P = 격자 레이아웃
hl.bind(
    mainMod .. " + P",
    hl.dsp.window.pseudo()
)

-- SUPER + J = 창 레이아웃 가로/세로 바꿈
hl.bind(
    mainMod .. " + J",
    hl.dsp.layout("togglesplit")
)

-- SUPER + CTRL + S = 영역 선택 스크린샷
hl.bind(
    mainMod .. " + CTRL + S",
    hl.dsp.exec_cmd(
        "grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
    )
)


-- =========================================================
-- 16. 창 포커스 이동
-- =========================================================

-- SUPER + 방향키
hl.bind(
    mainMod .. " + left",
    hl.dsp.focus({
        direction = "left"
    })
)

hl.bind(
    mainMod .. " + right",
    hl.dsp.focus({
        direction = "right"
    })
)

hl.bind(
    mainMod .. " + up",
    hl.dsp.focus({
        direction = "up"
    })
)

hl.bind(
    mainMod .. " + down",
    hl.dsp.focus({
        direction = "down"
    })
)


-- =========================================================
-- 17. Workspace 전환
-- =========================================================

-- SUPER + 숫자
-- 해당 Workspace로 이동

-- SUPER + SHIFT + 숫자
-- 현재 창을 해당 Workspace로 이동

for i = 1, 10 do

    -- 10번째 Workspace는 숫자 0으로 표현
    local key = i % 10

    hl.bind(
        mainMod .. " + " .. key,
        hl.dsp.focus({
            workspace = i
        })
    )

    hl.bind(
        mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({
            workspace = i
        })
    )
end


-- =========================================================
-- 18. Special Workspace
-- =========================================================

-- SUPER + S = Scratchpad 열기 / 닫기
hl.bind(
    mainMod .. " + S",
    hl.dsp.workspace.toggle_special("magic")
)

-- =========================================================
-- 19. 마우스 휠로 Workspace 이동
-- =========================================================

-- SUPER + 마우스 휠 아래
hl.bind(
    mainMod .. " + mouse_down",
    hl.dsp.focus({
        workspace = "e+1"
    })
)

-- SUPER + 마우스 휠 위
hl.bind(
    mainMod .. " + mouse_up",
    hl.dsp.focus({
        workspace = "e-1"
    })
)


-- =========================================================
-- 20. 마우스로 창 이동 / 크기 조절
-- =========================================================

-- SUPER + 왼쪽 클릭 드래그
-- 창 이동
hl.bind(
    mainMod .. " + mouse:272",
    hl.dsp.window.drag(),
    {
        mouse = true
    }
)


-- SUPER + 오른쪽 클릭 드래그
-- 창 크기 조절
hl.bind(
    mainMod .. " + mouse:273",
    hl.dsp.window.resize(),
    {
        mouse = true
    }
)


-- =========================================================
-- 21. 볼륨 / 밝기 / 미디어 키
-- =========================================================

-- 볼륨 증가
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ),
    {
        locked = true,
        repeating = true
    }
)

-- 볼륨 감소
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd(
        "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ),
    {
        locked = true,
        repeating = true
    }
)

-- 음소거
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ),
    {
        locked = true,
        repeating = true
    }
)

-- 마이크 음소거
hl.bind(
    "XF86AudioMicMute",
    hl.dsp.exec_cmd(
        "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ),
    {
        locked = true,
        repeating = true
    }
)

-- 화면 밝기
hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd(
        "brightnessctl -e4 -n2 set 5%+"
    ),
    {
        locked = true,
        repeating = true
    }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd(
        "brightnessctl -e4 -n2 set 5%-"
    ),
    {
        locked = true,
        repeating = true
    }
)

-- 미디어 제어
hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    {
        locked = true
    }
)

hl.bind(
    "XF86AudioPause",
    hl.dsp.exec_cmd("playerctl play-pause"),
    {
        locked = true
    }
)

hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    {
        locked = true
    }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    {
        locked = true
    }
)


-- =========================================================
-- 22. 창 규칙
-- =========================================================

-- 전체 창의 Maximize 요청 무시
local suppressMaximizeRule = hl.window_rule({

    name = "suppress-maximize-events",

    match = {
        class = ".*"
    },

    suppress_event = "maximize",
})

-- XWayland 창 드래그 문제 해결
hl.window_rule({

    name = "fix-xwayland-drags",

    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


-- =========================================================
-- 23. Hyprland Run 창
-- =========================================================
-- Hyprland Run 창을 화면 오른쪽 아래에 Floating으로 배치
hl.window_rule({

    name = "move-hyprland-run",

    match = {
        class = "hyprland-run"
    },

    move = "20 monitor_h-120",

    float = true,
})


-- =========================================================
-- 설정 끝
-- =========================================================
```
