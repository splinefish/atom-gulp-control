GulpControlView = require './gulp-control-view'
{CompositeDisposable} = require 'atom'

module.exports = GulpControl =
  modalPanel: null
  gulpView: null

  activate: (state) ->
    atom.workspaceView.command "gulp-control:toggle", => @toggle()

    this.newView()

    # Setup status bar icon
    # FIXME: To whatever the new way is for adding a element to the statusbar
    #        since this throws a deprecated warning.
    # TODO: Show some kind of mark on the icon if a task is running
    @statusBar = atom.workspaceView.statusBar

    if @statusBar?
      # TODO: Create a view class for this
      @statusBarTile = document.createElement('div')
      @statusBarTile.classList.add('inline-block')

      @tileIcon = document.createElement('span')
      #@tileIcon.classList.add('icon', 'icon-gulp-gray-16px')
      @tileIcon.classList.add('icon', 'icon-terminal')
      @statusBarTile.appendChild(@tileIcon)
      # icon-terminal

      @tileText = document.createElement('span')
      @tileText.textContent = "GULP"
      @statusBarTile.appendChild(@tileText)

      @statusBarTile.onclick = =>
        this.toggle()

      @statusBar.appendRight(@statusBarTile)

    return

  deactivate: ->
    console.log 'GulpControl: deactivate'
    @modalPanel.destroy()
    @gulpView.destroy()
    @statusBarTile?.destroy()
    @statusBarTile = null
    return

  newView: ->
    console.log 'gulp-control Creating a new view'
    @gulpView = new GulpControlView()
    @modalPanel = atom.workspace.addBottomPanel(item: @gulpView.getElement(), visible: true)

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
