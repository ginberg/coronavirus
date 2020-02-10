# ----------------------------------------
# --     PROGRAM ui_sidebar_right.R     --
# ----------------------------------------
# USE: Create UI elements for the
#      application sidebar (right side on
#      the desktop; contains options) and
#      ATTACH them to the UI by calling
#      add_ui_sidebar_right()
#
# NOTEs:
#   - All variables/functions here are
#     not available to the UI or Server
#     scopes - this is isolated
# ----------------------------------------

# -- IMPORTS --



# ----------------------------------------
# --   RIGHT SIDEBAR ELEMENT CREATION   --
# ----------------------------------------

# -- Create Elements

tab1 <- rightSidebarTabContent(
    id = 1,
    icon = NULL,
    title = NULL,
    active = TRUE,
    uiOutput("about_text"))

# # -- Register Basic Elements in the ORDER SHOWN in the UI
add_ui_sidebar_right(list(tab1))
