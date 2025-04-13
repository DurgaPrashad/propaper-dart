"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Check, Clock, Edit, Plus, Trash, Palette, Lock, CheckCircle2 } from "lucide-react"
import { Badge } from "@/components/ui/badge"
import { Slider } from "@/components/ui/slider"
import { Switch } from "@/components/ui/switch"
import { Label } from "@/components/ui/label"
import { useToast } from "@/components/ui/use-toast"

export default function Home() {
  const router = useRouter()
  const { toast } = useToast()
  const [activeTab, setActiveTab] = useState("dashboard")
  const [isPremium, setIsPremium] = useState(false)
  const [tasks, setTasks] = useState([
    { id: 1, title: "Team meeting", time: "10:00 AM", priority: "high", completed: false, category: "work" },
    { id: 2, title: "Grocery shopping", time: "4:30 PM", priority: "medium", completed: false, category: "personal" },
    { id: 3, title: "Finish project proposal", time: "6:00 PM", priority: "high", completed: false, category: "work" },
    { id: 4, title: "Call mom", time: "7:30 PM", priority: "low", completed: false, category: "personal" },
  ])

  const [editingTask, setEditingTask] = useState(null)
  const [wallpaperSettings, setWallpaperSettings] = useState({
    background: "black_white",
    font: "Inter",
    fontSize: "medium",
    showType: "all",
    contrast: 50,
    brightness: 50,
    autoUpdate: true,
  })

  // Check if user is logged in
  useEffect(() => {
    const isLoggedIn = localStorage.getItem("isLoggedIn")
    if (!isLoggedIn) {
      router.push("/login")
    }
  }, [router])

  // Update tasks based on current time (for demo purposes)
  useEffect(() => {
    if (wallpaperSettings.autoUpdate) {
      const interval = setInterval(() => {
        const now = new Date()
        const currentHour = now.getHours()
        const currentMinute = now.getMinutes()

        // Auto-complete tasks that have passed their time
        setTasks((prevTasks) =>
          prevTasks.map((task) => {
            const [hourStr, minuteStr] = task.time.split(":")
            const isPM = task.time.toLowerCase().includes("pm")
            let taskHour = Number.parseInt(hourStr)
            if (isPM && taskHour !== 12) taskHour += 12
            if (!isPM && taskHour === 12) taskHour = 0
            const taskMinute = Number.parseInt(minuteStr)

            if (currentHour > taskHour || (currentHour === taskHour && currentMinute > taskMinute)) {
              return { ...task, completed: true }
            }
            return task
          }),
        )
      }, 60000) // Check every minute

      return () => clearInterval(interval)
    }
  }, [wallpaperSettings.autoUpdate])

  const handleTaskComplete = (id) => {
    setTasks(tasks.map((task) => (task.id === id ? { ...task, completed: !task.completed } : task)))
  }

  const handleDeleteTask = (id) => {
    setTasks(tasks.filter((task) => task.id !== id))
  }

  const handleEditTask = (task) => {
    setEditingTask(task)
    setActiveTab("edit")
  }

  const handleAddTask = () => {
    setEditingTask(null)
    setActiveTab("edit")
  }

  const handleSaveTask = (task) => {
    if (editingTask) {
      setTasks(tasks.map((t) => (t.id === task.id ? task : t)))
    } else {
      setTasks([...tasks, { ...task, id: Date.now() }])
    }
    setActiveTab("dashboard")
    toast({
      title: editingTask ? "Task updated" : "Task added",
      description: `Successfully ${editingTask ? "updated" : "added"} "${task.title}"`,
    })
  }

  const handleWallpaperSettingChange = (setting, value) => {
    setWallpaperSettings({
      ...wallpaperSettings,
      [setting]: value,
    })
  }

  const handleSetWallpaper = () => {
    toast({
      title: "Wallpaper Applied",
      description: "Your tasks are now visible on your home screen",
      action: (
        <div className="h-8 w-8 bg-green-500 rounded-full flex items-center justify-center">
          <CheckCircle2 className="h-5 w-5 text-white" />
        </div>
      ),
    })
  }

  const handleUpgradeToPremium = () => {
    setIsPremium(true)
    toast({
      title: "Premium Activated",
      description: "You now have access to all premium features",
      variant: "premium",
    })
  }

  return (
    <div className="container mx-auto p-4 max-w-md md:max-w-2xl">
      <Card className="border-none shadow-lg">
        <CardHeader className="pb-2">
          <div className="flex items-center justify-between">
            <div>
              <CardTitle className="text-2xl font-bold">ProPaper</CardTitle>
              <CardDescription>Task-based live wallpaper</CardDescription>
            </div>
            {isPremium ? (
              <Badge variant="premium" className="bg-gradient-to-r from-amber-500 to-pink-500">
                PREMIUM
              </Badge>
            ) : (
              <Button variant="outline" size="sm" onClick={handleUpgradeToPremium}>
                Upgrade
              </Button>
            )}
          </div>
        </CardHeader>
        <CardContent>
          <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
            <TabsList className="grid grid-cols-3 mb-4">
              <TabsTrigger value="dashboard">Dashboard</TabsTrigger>
              <TabsTrigger value="edit">Edit Task</TabsTrigger>
              <TabsTrigger value="wallpaper">Wallpaper</TabsTrigger>
            </TabsList>

            <TabsContent value="dashboard" className="space-y-4">
              <div className="flex justify-between items-center">
                <h3 className="text-lg font-medium">Your Tasks</h3>
                <Button size="sm" onClick={handleAddTask}>
                  <Plus className="h-4 w-4 mr-1" /> Add Task
                </Button>
              </div>

              <div className="space-y-2">
                {tasks.map((task) => (
                  <Card
                    key={task.id}
                    className={`border ${task.completed ? "bg-muted" : getPriorityColor(task.priority)}`}
                  >
                    <CardContent className="p-3 flex items-center justify-between">
                      <div className="flex items-center gap-2">
                        <Button
                          variant="outline"
                          size="icon"
                          className="h-6 w-6 rounded-full"
                          onClick={() => handleTaskComplete(task.id)}
                        >
                          {task.completed && <Check className="h-3 w-3" />}
                        </Button>
                        <div className={task.completed ? "line-through text-muted-foreground" : ""}>
                          <p className="font-medium">{task.title}</p>
                          <div className="flex items-center text-xs text-muted-foreground">
                            <Clock className="h-3 w-3 mr-1" /> {task.time}
                          </div>
                        </div>
                      </div>
                      <div className="flex gap-1">
                        <Button variant="ghost" size="icon" className="h-7 w-7" onClick={() => handleEditTask(task)}>
                          <Edit className="h-4 w-4" />
                        </Button>
                        <Button
                          variant="ghost"
                          size="icon"
                          className="h-7 w-7"
                          onClick={() => handleDeleteTask(task.id)}
                        >
                          <Trash className="h-4 w-4" />
                        </Button>
                      </div>
                    </CardContent>
                  </Card>
                ))}

                {tasks.length === 0 && (
                  <div className="text-center py-8 text-muted-foreground">
                    <p>No tasks yet. Add your first task to get started!</p>
                  </div>
                )}
              </div>
            </TabsContent>

            <TabsContent value="edit">
              <TaskEditForm task={editingTask} onSave={handleSaveTask} onCancel={() => setActiveTab("dashboard")} />
            </TabsContent>

            <TabsContent value="wallpaper">
              <div className="md:grid md:grid-cols-2 md:gap-6">
                <div>
                  <WallpaperSettings
                    settings={wallpaperSettings}
                    onChange={handleWallpaperSettingChange}
                    isPremium={isPremium}
                    onUpgrade={handleUpgradeToPremium}
                  />
                  <div className="mt-4">
                    <Button className="w-full" onClick={handleSetWallpaper}>
                      Set as Wallpaper
                    </Button>
                  </div>
                </div>
                <div className="mt-6 md:mt-0 flex justify-center">
                  <WallpaperPreview tasks={tasks} settings={wallpaperSettings} isPremium={isPremium} />
                </div>
              </div>
            </TabsContent>
          </Tabs>
        </CardContent>
        <CardFooter className="flex justify-center border-t pt-4">
          <p className="text-xs text-muted-foreground">ProPaper v1.0</p>
        </CardFooter>
      </Card>
    </div>
  )
}

function getPriorityColor(priority) {
  switch (priority) {
    case "high":
      return "border-l-4 border-l-red-500"
    case "medium":
      return "border-l-4 border-l-yellow-500"
    case "low":
      return "border-l-4 border-l-green-500"
    default:
      return ""
  }
}

function TaskEditForm({ task, onSave, onCancel }) {
  const [formData, setFormData] = useState(
    task
      ? { ...task }
      : {
          title: "",
          time: "",
          priority: "medium",
          category: "personal",
          completed: false,
        },
  )

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData({ ...formData, [name]: value })
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    onSave(formData)
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="space-y-2">
        <label htmlFor="title" className="text-sm font-medium">
          Task Title
        </label>
        <input
          id="title"
          name="title"
          className="w-full p-2 border rounded-md"
          value={formData.title}
          onChange={handleChange}
          required
        />
      </div>

      <div className="space-y-2">
        <label htmlFor="time" className="text-sm font-medium">
          Time
        </label>
        <input
          id="time"
          name="time"
          className="w-full p-2 border rounded-md"
          value={formData.time}
          onChange={handleChange}
          placeholder="e.g. 3:30 PM"
          required
        />
      </div>

      <div className="space-y-2">
        <label htmlFor="priority" className="text-sm font-medium">
          Priority
        </label>
        <select
          id="priority"
          name="priority"
          className="w-full p-2 border rounded-md"
          value={formData.priority}
          onChange={handleChange}
        >
          <option value="high">High</option>
          <option value="medium">Medium</option>
          <option value="low">Low</option>
        </select>
      </div>

      <div className="space-y-2">
        <label htmlFor="category" className="text-sm font-medium">
          Category
        </label>
        <select
          id="category"
          name="category"
          className="w-full p-2 border rounded-md"
          value={formData.category}
          onChange={handleChange}
        >
          <option value="work">Work</option>
          <option value="personal">Personal</option>
          <option value="health">Health</option>
          <option value="education">Education</option>
        </select>
      </div>

      <div className="flex gap-2 pt-2">
        <Button type="submit" className="flex-1">
          {task ? "Update Task" : "Add Task"}
        </Button>
        <Button type="button" variant="outline" onClick={onCancel} className="flex-1">
          Cancel
        </Button>
      </div>
    </form>
  )
}

function WallpaperSettings({ settings, onChange, isPremium, onUpgrade }) {
  return (
    <div className="space-y-4">
      <h3 className="text-lg font-medium">Wallpaper Settings</h3>

      <div className="space-y-2">
        <label htmlFor="background" className="text-sm font-medium">
          Background
        </label>
        <select
          id="background"
          className="w-full p-2 border rounded-md"
          value={settings.background}
          onChange={(e) => onChange("background", e.target.value)}
        >
          <option value="black_white">Black & White</option>
          <option value="solid_black">Solid Black</option>
          <option value="solid_white">Solid White</option>
          {isPremium ? (
            <>
              <option value="gradient_purple">Gradient Purple</option>
              <option value="gradient_blue">Gradient Blue</option>
              <option value="gradient_green">Gradient Green</option>
              <option value="image">Custom Image</option>
            </>
          ) : (
            <option value="premium" disabled>
              Premium Gradients (Upgrade)
            </option>
          )}
        </select>
      </div>

      {settings.background === "black_white" && (
        <div className="space-y-2">
          <div className="flex items-center justify-between">
            <label htmlFor="contrast" className="text-sm font-medium">
              Contrast
            </label>
            <span className="text-xs text-muted-foreground">{settings.contrast}%</span>
          </div>
          <Slider
            id="contrast"
            min={0}
            max={100}
            step={1}
            value={[settings.contrast]}
            onValueChange={(value) => onChange("contrast", value[0])}
          />
        </div>
      )}

      <div className="space-y-2">
        <label htmlFor="font" className="text-sm font-medium">
          Font
        </label>
        <select
          id="font"
          className="w-full p-2 border rounded-md"
          value={settings.font}
          onChange={(e) => onChange("font", e.target.value)}
        >
          <option value="Inter">Inter</option>
          <option value="Roboto">Roboto</option>
          <option value="Poppins">Poppins</option>
          {isPremium && <option value="Montserrat">Montserrat</option>}
        </select>
      </div>

      <div className="space-y-2">
        <label htmlFor="fontSize" className="text-sm font-medium">
          Font Size
        </label>
        <select
          id="fontSize"
          className="w-full p-2 border rounded-md"
          value={settings.fontSize}
          onChange={(e) => onChange("fontSize", e.target.value)}
        >
          <option value="small">Small</option>
          <option value="medium">Medium</option>
          <option value="large">Large</option>
        </select>
      </div>

      <div className="space-y-2">
        <label htmlFor="showType" className="text-sm font-medium">
          Show Tasks
        </label>
        <select
          id="showType"
          className="w-full p-2 border rounded-md"
          value={settings.showType}
          onChange={(e) => onChange("showType", e.target.value)}
        >
          <option value="all">All Tasks</option>
          <option value="today">Today Only</option>
          <option value="priority">High Priority Only</option>
        </select>
      </div>

      <div className="flex items-center space-x-2 pt-2">
        <Switch
          id="auto-update"
          checked={settings.autoUpdate}
          onCheckedChange={(checked) => onChange("autoUpdate", checked)}
        />
        <Label htmlFor="auto-update">Auto-update based on time</Label>
      </div>

      {!isPremium && (
        <div className="mt-4 p-3 bg-muted rounded-lg border border-dashed flex items-center justify-between">
          <div className="flex items-center">
            <Lock className="h-4 w-4 mr-2 text-muted-foreground" />
            <span className="text-sm">Premium features</span>
          </div>
          <Button size="sm" variant="outline" onClick={onUpgrade}>
            Unlock
          </Button>
        </div>
      )}
    </div>
  )
}

function WallpaperPreview({ tasks, settings, isPremium }) {
  // Filter tasks based on settings
  const filteredTasks = tasks.filter((task) => {
    if (settings.showType === "priority") {
      return task.priority === "high" && !task.completed
    } else {
      return !task.completed
    }
  })

  // Get background style based on settings
  const getBackgroundStyle = () => {
    switch (settings.background) {
      case "black_white":
        const contrastValue = settings.contrast / 100
        return `bg-gradient-to-b from-gray-900 to-gray-${Math.round(9 - contrastValue * 9)}00`
      case "solid_black":
        return "bg-black"
      case "solid_white":
        return "bg-white"
      case "gradient_purple":
        return "bg-gradient-to-br from-purple-500 to-pink-500"
      case "gradient_blue":
        return "bg-gradient-to-br from-blue-500 to-indigo-500"
      case "gradient_green":
        return "bg-gradient-to-br from-green-400 to-teal-500"
      case "image":
        return "bg-[url(/placeholder.svg?height=400&width=225)] bg-cover"
      default:
        return "bg-gradient-to-br from-gray-900 to-gray-700"
    }
  }

  // Get text color based on background
  const getTextColor = () => {
    if (settings.background === "solid_white") {
      return "text-black"
    }
    return "text-white"
  }

  // Get font style based on settings
  const getFontStyle = () => {
    let fontClass = ""

    switch (settings.font) {
      case "Inter":
        fontClass += "font-sans"
        break
      case "Roboto":
        fontClass += "font-sans"
        break
      case "Poppins":
        fontClass += "font-sans"
        break
      case "Montserrat":
        fontClass += "font-sans"
        break
      default:
        fontClass += "font-sans"
    }

    switch (settings.fontSize) {
      case "small":
        fontClass += " text-xs"
        break
      case "medium":
        fontClass += " text-sm"
        break
      case "large":
        fontClass += " text-base"
        break
      default:
        fontClass += " text-sm"
    }

    return fontClass
  }

  // Get card background based on settings
  const getCardBackground = () => {
    if (settings.background === "solid_white") {
      return "bg-black/10"
    }
    return "bg-white/10 backdrop-blur-sm"
  }

  return (
    <div className="flex flex-col items-center">
      <h3 className="text-sm font-medium mb-2">Wallpaper Preview</h3>
      <div
        className={`w-[225px] h-[400px] rounded-xl overflow-hidden ${getBackgroundStyle()} flex flex-col justify-center items-center p-4 shadow-lg`}
      >
        <div className="w-full h-full flex flex-col justify-center">
          <div className={`${getTextColor()} text-center mb-4`}>
            <div className="text-xs opacity-70 mb-1">TODAY'S TASKS</div>
            <div
              className={`w-16 h-0.5 ${settings.background === "solid_white" ? "bg-black/30" : "bg-white/30"} mx-auto`}
            ></div>
          </div>

          <div className={`space-y-3 ${getFontStyle()}`}>
            {filteredTasks.length > 0 ? (
              filteredTasks.map((task) => (
                <div key={task.id} className={`${getCardBackground()} rounded-lg p-3 ${getTextColor()}`}>
                  <div className="font-medium">{task.title}</div>
                  <div className="text-xs opacity-70 flex items-center">
                    <Clock className="h-3 w-3 mr-1" /> {task.time}
                  </div>
                </div>
              ))
            ) : (
              <div className={`text-center ${getTextColor()} opacity-70`}>No tasks to display</div>
            )}
          </div>

          {isPremium && settings.background.startsWith("gradient") && (
            <div className="absolute bottom-3 right-3">
              <Palette className="h-4 w-4 text-white/50" />
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
