GulpControlView = require './gulp-control-view'
{CompositeDisposable} = require 'atom'

module.exports = GulpControl =
  modalPanel: null
  gulpView: null

  activate: (state) ->
    # FIXME: To whatever the new way is for adding a element to the statusbar
    #        since this throws a deprecated warning.
    # TODO: Show some kind of mark on the icon if a task is running
    # TODO: Dont start if the main folder does not contain a gulpfile.js|coffee
    #       Hook into some createfile event and check if the type is a gulpfile
    #       in that case, show up on the statusbar

    createStatusEntry = =>
      @statusBar = atom.workspaceView.statusBar

      # TODO: Create a view class for this
      @statusBarTile = document.createElement('div')
      @statusBarTile.classList.add('inline-block', 'gulp-control-status-tile')

      @tileIcon = document.createElement('span')
      #@tileIcon.classList.add('icon', 'icon-gulp-gray-16px')
      @tileIcon.classList.add('icon', 'icon-terminal')
      @statusBarTile.appendChild(@tileIcon)
      # icon-terminal

      @tileText = document.createElement('span')
      @tileText.textContent = "GULP"
      @statusBarTile.appendChild(@tileText)

      @statusBarTile.onclick = =>
        if !@gulpView
          this.newView()

        this.toggle()

      @statusBar.appendRight(@statusBarTile)

    if atom.workspaceView.statusBar
      createStatusEntry()
    else
      atom.packages.once 'activated', ->
        createStatusEntry()

    return

  deactivate: ->
    @modalPanel.destroy()
    @gulpView.destroy()
    @statusBarTile?.destroy()
    @statusBarTile = null
    return

  newView: ->
    @gulpView = new GulpControlView()
    @modalPanel = atom.workspace.addBottomPanel(item: @gulpView.getElement(), visible: false)

    return

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
      @gulpView.scrollToBottom()
      #@gulpView.clearGulpTasks()
      #@gulpView.getGulpTasks() this is what kills our process
      # We need to create a new bufferedprocess to get the tasks. We might
      # also want to put a right click context menu or something for refetching
      # instead of every time we open the window.

  serialize: ->
